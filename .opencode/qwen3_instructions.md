## Lua Code Quality Improvement Plan (Approved)

### Files Reviewed
- `lua/cc_core.lua`
- `lua/bridge_cc_core.lua`

### Issues Found (by priority)

#### P0 — Fix Immediately
1. **Duplicate function** (`cc_core.lua:224-230`): `cc_core.getSfr2Obj` is defined twice identically.
2. **Inconsistent module reference** (`cc_core.lua:line 3, +6 call sites`): Line 3 assigns to an unqualified global `cmn = require "common"`. Six call sites use bare `common.split_at_dot(key)`, which does not resolve to the same variable as `cmn`.

#### P1 — Clean Up Structure
3. **Pseudo-private mappers** (`cc_core.lua:76-77`): `verbatim_mapper` and `mod_mapper` are module-level functions attached to `cc_core` mid-declaration — confusing scoping.
4. **`__error__` sentinel pattern** (`cc_core.lua:354`): Magic string `"__error__"` used across the codebase for error signaling. Consider replacing with `nil` returns or an explicit error type for readability and debuggability.

#### P2 — Performance
5. **O(n²) table body generation** (`bridge_cc_core.lua:246-268`): `print_table_body` iterates over all headers for every row cell. Convert to an O(n) approach using a lookup table keyed by header label.

### Execution Order (updated after P0-2 verification failed)
1. **P0-1**: Remove duplicate `cc_core.getSfr2Obj` function definition. Run tests.
2. **P0-2a**: Line 3 → `local cmn = require "common"`. Run tests to confirm baseline works.
3. **P0-2b**: Updated call sites (lines 348, 361, 399, 428, 437, 444) from `common.split_at_dot()` → `cmn.split_at_dot()`. **Do NOT use blanket file replace** — it matches the string literal in `require "common"`. Use surgical edits only. Run tests after each change.

### Positive Aspects to Maintain During Cleanup
- Clean separation of concerns between database access (`cc_core`), presentation logic (`bridge_cc_`), and table generation (`table_generator`).
- The `mapper` pattern used in `querysets` is elegant and reusable.
- Good test coverage structure in `lua/*_test.lua`.

## General strategy
- Verify changes by running the tests in @lua/Makefile.
