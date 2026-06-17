# Lua Refactoring Plan

## Scope

8 remaining issues across `lua/*.lua`. Order by impact (correctness first) then grouped by file to minimize blast radius.

---

### Step 1: `pairs` → `ipairs` in table_generator.lua — correctness fix

**Why it matters:** `pairs` has no guaranteed iteration order in Lua. Rows are built as arrays and concatenated for LaTeX output — wrong order can produce garbled tables.

**Files:**
- `lua/table_generator.lua`: line 75, 125, 142, 166 — change `pairs` to `ipairs`
- `lua/tls.lua:22` — `for tlsid in pairs(tls.connections)` — keys are table IDs (strings), not indices. This is OK as-is since the key lookup on line 31 uses the same iteration variable. **Do NOT change this one.**

**Verification:** Run `make -C lua test_table_generator` after each change.

---

### Step 2: `_G.db_core` hidden dependency in common.lua — correctness fix

**Why it matters:** `common.check_for_errors()` and `common.get_by_query_key()` reach into `_G.db_core`. This is runtime coupling with zero static detection. Renaming the module or changing init order silently breaks everything.

**Files:**
- `lua/common.lua` — add explicit import at top of file:
  ```lua
  local dbcore = require "db_core"
  ```
- Update line 42: `_G.db_core.read_from_db` → `dbcore.read_from_db`
- Update line 54: `_G.db_core.has_error` → `dbcore.has_error`

**Note:** This adds a circular edge: `common ← db_core`. But `db_core` does NOT require `common` (it's the leaf). We added `cmn = require "common"` to db_core earlier — verify that `db_core`'s require of `common` doesn't itself require `db_core` back. The cycle would be `common → db_core → common`. Check if any function in `common` is called during `db_core`'s module initialization (top-level code). If yes, this step needs a different approach — see Step 6 first.

**Verification:** Full test suite passes. Common concern: require-cycle on init.

---

### Step 3: Bridge file passthrough wrappers — DRY reduction

**Why it matters:** `bridge_cc_core.lua` (271 lines) and `bridge_tls.lua` (20 lines) are ~90% dead-weight single-line wrappers that just call a library function and pass the result to `tex.sprint`. These add no logic, only indirection.

**Approach — auto-wire bridges via metatable:**
- In each bridge file, define a generic passthrough:
  ```lua
  setmetatable(bridge_cc_core, {
      __index = function(tbl, funcname)
          return function(...)
              local result = cc_core[funcname](...)
              -- We need tex from the caller — this doesn't work with plain __index
          end
      end,
  })
  ```
- **Problem:** `tex` is passed by LuaTeX at macro call site, not available in the bridge layer. So a metatable approach only works if we expose functions directly to TeX and let the TeX macro handle `tex.sprint`. This requires changes in the `.tex` side (the `bridge_*.tex` files), which is out of scope for this Lua-only pass.
- **Alternative:** Keep bridges as-is. Accept that they're a structural necessity of the LuaTeX bridge model. Move to a documentation note rather than code change.

**Verdict:** Skip code changes. Document in AGENTS.md that bridges are intentional LuaTeX interface contracts, not dead weight.

---

### Step 4: SQL queryset validation — schema drift protection

**Why it matters:** All 20+ SQL queries are raw strings with hardcoded table/column names. If the schema (defined in `table_definitions`) changes without query updates, errors surface at runtime during typesetting — slow feedback loop.

**Approach:** Add a `validate_queries()` function that runs at module init time:
- For each queryset, do a simple column/table name cross-reference against `table_definitions`
- Report mismatches (missing columns/tables) as assert failures
- Keeps O(1) startup cost for a one-time check

**Files:** Add to end of `cc_core.lua` before the final return, or in `bridge_common.lua` where init already runs.

**Verification:** Run with an intentional schema mismatch to confirm detection. Then restore and run full test suite.

---

### Step 5: Getter boilerplate in cc_core.lua — DRY reduction

**Why it matters:** 22 functions follow the identical pattern `return cmn.get_by_query_key("key", key)`. This adds ~40 lines of copy-paste that can obscure real logic and invites typos.

**Approach — metatable delegation:**
- Remove all 22 getter functions
- Replace with a single metatable on `cc_core` that auto-delegates:
  ```lua
  setmetatable(cc_core, {
      __index = function(tbl, key)
          local mapper = QUERY_MAPPERS[key]
          if mapper then
              return function(query_key)
                  return cmn.get_by_query_key(query_key, ...)
              end
          end
      end,
  })
  ```
- Or simpler: define a `make_getter` factory and use it to build the remaining functions in bulk.

**Verification:** Run full test suite after removal — any missing/changed getter will break tests immediately.

---

### Step 6: Circular dependency resolution (if Step 2 requires it)

**Why:** If `db_core` requires `common`, and we make `common` require `db_core`, they'll cycle on init if either calls into the other during top-level execution.

**Check:** Read both files' top-level code paths. `db_core.lua` has no circular risk at init — it only defines functions, doesn't call them. `common.lua` also only defines functions. The actual require cycles are:
- `bridge_cc_core → cc_core → common` (ok, linear)
- `bridge_common → db_core → common` (ok, linear)

Adding `common → db_core` creates the cycle `common ↔ db_core`. To break it, use **require-time injection**: instead of `require "db_core"` at the top of `common`, do it inside each function:
```lua
function common.get_by_query_key(querykey, key)
    local dbcore = require "db_core"
    return dbcore.read_from_db(querykey, {string.lower(key)})
    ...
end
```

This defers the require until runtime when both modules are already fully initialized. **Only apply if Step 2 blocks on circular init.**

---

### Step 7: German comments — consistency

**Files:**
- `lua/cc_core.lua:401-405` — German block comment explaining `get_module_status`

Change to English. One-line is sufficient:
```lua
-- Returns module status: \enfc if enforcing SFR exists, \supp if supporting, \nontsf otherwise.
```

---

### Step 8: Trailing whitespace in tls.lua — hygiene

**File:** `lua/tls.lua` lines 60-67 (4 trailing blank lines after `return tls`)

Delete trailing empty lines so the file ends cleanly after line 62 (`return tls`).

---

## Summary of changes by file

| File | Step | Change type |
|------|------|-------------|
| `table_generator.lua` | 1 | correctness (pairs→ipairs) |
| `common.lua` | 2/6 | correctness (_G→explicit require) |
| `cc_core.lua` | 4/5 | validation + DRY |
| `tls.lua` | 8 | hygiene (trailing whitespace) |
| `cc_core.lua` | 7 | consistency (German→English) |

## Validation strategy

Run after all steps: `make -C lua test` (96 tests). Run incrementally where noted. Any test failure pins which step introduced a regression.
