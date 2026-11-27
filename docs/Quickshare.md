Building GNU Texinfo (.texi or .texinfo) documents relies on a small set of command-line tools. The primary translator is **texi2any** (commonly symlinked or aliased as **makeinfo**), which converts Texinfo source into Info, HTML, plain text, XML, DocBook, EPUB, LaTeX, or printed formats via TeX.
### Core Build Commands
| Command | Purpose & Output | Typical Usage |
|---|---|---|
| **makeinfo / texi2any** | Main translator; defaults to **Info** format (.info), or converts to other formats via flags. | makeinfo manual.texi |
| **texi2any --html** | Generates HTML documentation (split into pages/nodes or single file depending on options). | texi2any --html manual.texi |
| **texi2any --plaintext** | Outputs plain text without Info node/menu control characters. | texi2any --plaintext manual.texi |
| **texi2pdf / texi2dvi --pdf** | Runs TeX/pdfTeX and index/cross-reference passes to produce a **PDF**. | texi2pdf manual.texi |
| **texi2dvi** | Formats the document into a **DVI** file (and handles texindex / TeX passes automatically). | texi2dvi manual.texi |
| **install-info** | Adds or updates a .info file entry in the Info dir index file. | install-info manual.info /usr/share/info/dir |
### Common makeinfo / texi2any Options
 * **Output location (-o DEST / --output=DEST)**: Writes output to a specific file or directory. For split HTML, DEST names the target directory (e.g., makeinfo --html -o out_html manual.texi).
 * **Single-file vs. split output (--no-split, --split=SPLIT)**: --no-split keeps output in one file; for HTML, --split can be set to chapter, section, or node.
 * **Include paths (-I DIR, -P DIR)**: Appends (-I) or prepends (-P) directories searched for @include files.
 * **Variables (-D VAR, -U VAR)**: Defines (-D) or undefines (-U) Texinfo variables equivalent to @set and @clear in the source.
 * **Formatting & validation**:
   * --fill-column=NUM sets line wrapping width for Info/plain text (default is 72).
   * --no-validate skips cross-reference/node validation.
   * -v / --verbose prints progress details.
### Makefile & Local Project Builds
Many repositories (including projects using Autotools or custom Makefile setups) wrap these commands behind make targets such as:
```bash
make info    # Build Info documentation
make html    # Build HTML documentation
make pdf     # Build PDF documentation (typically requires a TeX distribution like TeX Live)
make clean   # Remove generated build artifacts

```
*(Note: If you are working on a specific repository or Makefile—such as the one open in your browser—share which target or format you're aiming for and I can help trace the exact commands it runs.)*

Quick Ways to Share Them

You can inspect and paste the relevant details directly from your terminal or browser:
1. Check cleanup.mk and test/ locally:bash
cat cleanup.mk
ls -la test/
Use code with caution.
(Paste the output here and I will verify how cleanup.mk integrates with your Makefile and whether test/ conflicts with modules/lmlmxtend-runtime/tests/.)
2. Check Your GitHub Actions Status:
	• Open the Actions tab on auraecosystem/Texi- in your browser, or run the GitHub CLI from your terminal:bash
gh run list --limit 3
gh run view --log-failed
Use code with caution.
(If any step shows a red X, paste the error log here so I can provide the exact fix.)

Quick Integration Check for cleanup.mk

If you want your root Makefile to automatically pull in cleanup.mk for removing TeX and Terraform build artifacts, add this line near the top of your Makefile:
makefile
-include cleanup.mk
Use code with caution.
(The leading - ensures make will not fail even if cleanup.mk is moved or renamed later.)
Please paste the contents of cleanup.mk, the files inside test/, or any failing GitHub Actions log output, and I will review and wire everything cleanly together.
