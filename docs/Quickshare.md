
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
