# n-doc Repository Guide

## What this repo is
Platform for creating Common Criteria documentation with LaTeX. Sample documents ("Mauve VPN Client") serve as templates. Main documents: Security Target (`ase`), Functional Specification (`adv_fsp`), TOE Design Specification (`adv_tds`).

## Building
- **Primary**: `./runmake.sh [goal]` — runs docs in the `ndesign/n-doc` Docker container. Default goal is `delivery`.
- **Specific document**: `./runmake.sh ase` (or `fsp`, `tds`, `arc`, `ate`, `ref`, `alc`, `db`)
- **Root Makefile goals**: `all` (build everything), `delivery` (build + copy PDFs to `deliverables/` with versioned names), `clean`, `mwe`/`cleanmwe`
- Running directly inside a running container: `./ndoc.sh make [goal]`

## Repo structure
- `ase/`, `adv_fsp/`, `adv_tds/`, `adv_arc/`, `ate_cov/`, `alc/`, `reflist/` — individual document source dirs (each has its own `Makefile` + `.latexmkrc`). Main doc must match dir name, e.g. `adv_fsp/adv_fsp.tex`.
- `common/` — shared TeX macros, packages, preamble, index defs, l10n, media.
- `lua/` — Lua libraries used by the doc toolchain (db_core, cc_core, bridge_\*, documents, tables, etc.) plus test files.
- `scripts/` — build/ops scripts: `add_document.sh`, `remove_document.sh`, `release_documents.sh`, `transform-wsd.sh`, `cleanup.sh`, `prepare_mwe.sh`, `sfr_checker.lua`, etc. Skeleton template in `scripts/_skeleton/`.
- `engine/` — Docker image build files (TeX Live, SQLite, PlantUML). Build with `make n-doc` in `engine/`.
- `mwe_*` — Minimal Working Examples as quick-test environments. Edit `mwe_<type>_body.tex` (gitignored), not the main `\*.tex`.

## Adding / removing documents
- `scripts/add_document.sh <type>` — generates from `scripts/_skeleton/` and updates root Makefile.
- `scripts/remove_document.sh <type>` — deletes dir and removes from Makefile.

## Branching / PR workflow
- Feature branches off `main`. No direct pushes to `main`.
- Prefer rebasing before merging (`git rebase` or `git pull --rebase`).
- External contributors use `scripts/create-patch.sh` / `process-patch.sh` workflow.

## Generated / ignored
- All `*.pdf`, `*.aux`, `*.bbl`, `*.log`, and other TeX aux files → gitignored.
- `deliverables/`, `*.patch`, MWE `*_body.tex`, `.db-journal`, `_minted-*/`, `auto/` → gitignored.
- `common/auto/`, `ase/auto/` — auto-generated LaTeX expansion files.

## LaTeX toolchain notes
- Uses `latexmk`, `lualatex`, `\usepackage` hooks via `common/common-packages.tex` / `common/common-preamble.tex`.
- Custom macros in `common/common-macros.tex`, `common/cc_core-macros.tex`, etc.
- Code listings use `\minted` (requires `--shell-escape`).
- Sweave/wsd files transform with `scripts/transform-wsd.sh`.

## Release
- `scripts/release_documents.sh` — bumps version and tags.
- Engine version pinned in `.github/workflows/build_n-doc_template.yml`.


## Additional Information and Instructions 

### n-doc background

I developed n-doc iteratively along the creation of CC documentation for a
particular product. When the platform turned out to be quite successful, I
decided to open-source it. n-doc is my first attempt at writing lua code. In
fact, I learned lua just to write the code that is now plugged into the TeX
typesetting process. I am an experienced Java developer with a strong background
in bash scripting and unix.

### Lua functionality

Upon startup of the typesetting process, LuaTeX invokes the Lua
programs. Immediately, a sqlite database is created in memory. Tables are
created and the database is populated from CSV files. The user calls LaTeX
macros which in turn call Lua programs to run queries in the database. Usually,
the results are transformed into formatted LaTeX code and printed into the
typesetting process. This way, among other things, abbreviations are expanded,
tables are generated and hyperlinks are created.

### Architectural considerations for the Lua parts of n-doc

The Lua parts of n-doc follow a strict architecture. The goal was to keep Lua
code as independent as possible from the LaTeX macros to ensure fast turnaround
when testing: calling lua and running the tests is faster than calling lualatex,
because no TeX format files must be loaded.

The Lua code is layered in the following way. I'm using the cc_core package as
an example. There are packages defined in the @common/db/config file. Consider
all packages defined there. Now for the layering:

LaTeX macro is defined in common/cc_core-macros.tex.  The macro calls a Lua
function in common/bridge_cc_core.tex. The functions defined there contain no
functionality. They just call identically named functions in
lua/bridge_cc_core.lua. They contain business logic for aggregating e.g. several
database calls and formatting the output. Any database specific code is in
cc_core.lua. To summarize:

cc_core-macros.tex -> bridge_cc_core.tex -> bridge_cc_core.lua -> cc_core.lua

The "bridge" metaphor manifests the division between the LaTeX world and the Lua
world, which can be called independently of LuaTeX. The further away from TeX we
get, the purer the Lua code is.
