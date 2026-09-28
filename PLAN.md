# Lua Code Improvement Plan

## Phase 1 — Bugs / Correctness Issues

- [x] **1. `tls.lazyinit()` guard is broken** — `tls.initialized` is checked but never set to `true`, so CSV is re-parsed on every call. (`lua/tls.lua:5`)
- [x] **2. `bridge_common.remove_smart_hyphen` missing `tex` parameter** — function signature is `(key)` but calls `tex.sprint(result)`, relying on global `tex`. Inconsistent with all other bridge functions. (`lua/bridge_common.lua:23-26`)
- [x] **3. `cc_core.getSfr2Obj` defined twice** — identical copy-paste at lines 224-230. Second silently overwrites the first. (`lua/cc_core.lua:224-230`)
- [ ] **4. Duplicate global `insert_error`** — defined as a global in both `db_core.lua:71` and `cc_core.lua:353`. Whichever loads last wins. (`lua/db_core.lua:71`, `lua/cc_core.lua:353`)
- [ ] **5. Double DB initialization in test setup** — `init_test_db.lua` calls `bridge.init()` (which calls `db_core.init()`), then calls a standalone `init()` that does the same thing again. (`lua/init_test_db.lua`)

## Phase 2 — Global Variable Pollution

- [ ] **6. Module-private functions are inadvertently global** — helper functions in `db_core.lua`, `table_generator.lua`, `bridge_cc_core.lua` lack `local`. (`db_core.lua:16-69`, `table_generator.lua:163`, `bridge_cc_core.lua:213`)
- [ ] **7. Module tables themselves are global** — `common = {}`, `cc_core = {}`, `dbcore = {}`, `documents = {}`, `tg = {}`, all bridges. Only `tls.lua` correctly uses `local`. (all module files)
- [ ] **8. Temp/loop variables leak into global scope** — `configfile`, `st`, `connections`, `tableentry`, `conntable`, `docversion`, `labels`, `row` all lack `local`. (various files)

## Phase 3 — Architecture / Design

- [ ] **9. Error handling via `"__error__"` magic string** — fragile sentinel value pattern across `db_core.lua`, `common.lua`, `cc_core.lua`. Idiomatic Lua uses `nil` + error message. (multiple files)
- [ ] **10. Boilerplate iterator pattern** — `all_table_definitions()`, `populate()`, `queries()` are copy-pasted with identical structure in `cc_core.lua` and `documents.lua`. (`cc_core.lua`, `documents.lua`)
- [ ] **11. `tls.lua` is an outlier** — parses its own CSV with a hardcoded relative path instead of integrating into the `db_core`/config framework. (`lua/tls.lua:7`)
- [ ] **12. `_G.db_core` coupling** — `common.lua` accesses `_G.db_core` explicitly, a workaround for global-based module wiring. (`lua/common.lua:27,34`)

## Phase 4 — Style and Idiomacy

- [ ] **13. Mixed naming conventions** — camelCase (`getSfr`) vs snake_case (`get_module_status`) with no clear rule. (all files)
- [ ] **14. Trailing semicolons** — scattered in a few places, not idiomatic Lua. (`cc_core.lua:76`, `common.lua:33`)
- [ ] **15. Mixed tab/space indentation** — e.g. `db_core.lua:46` uses tabs while surrounding code uses spaces. (various files)
- [ ] **16. `pairs` on sequential arrays** — many places use `pairs()` where `ipairs()` is correct for ordered iteration. (`db_core.lua`, `table_generator.lua`, bridge files)
- [ ] **17. Unused parameters** — `cc_core.getTestcases(srckey)`, `tls.printTlsConnectionTable(create_tdslinks)`, `tls.getTlsConnectionTableRow(key, create_tdslinks)`. (various files)
- [ ] **18. Parameter shadowing** — `local relationtype = relationtype or "enf"` shadows the parameter with a local of the same name. (`cc_core.lua:423,435,450`)
- [ ] **19. `require` inside function body** — `table_generator.lua:50` does `require("cc_core")` at call-time, obscuring the dependency. (`lua/table_generator.lua:50`)
- [ ] **20. Redundant table copy** — `cc_core.generate_table_sfr_to_module` copies a table element-by-element then returns it. Could return the original. (`lua/cc_core.lua:413-420`)
- [ ] **21. Dead code in tests** — loose debugging functions that are not actual tests. (`lua/test_cc_core.lua:211-249`)
- [ ] **22. Test init duplication** — `init_test_db.lua` and `init_test_bridge.lua` duplicate the `tex` mock setup. (`lua/init_test_db.lua`, `lua/init_test_bridge.lua`)
- [ ] **23. Inconsistent test table naming** — `test_cc_core`, `testcommon`, `testtg`, `testbridge` — no uniform convention. (test files)
