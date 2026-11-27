MANUAL := mymanual
TEXI_SOURCE := docs/mymanual.texinfo
TEXI_INCLUDE_FLAGS := -I docs -I doc -I doc/include -I my-manual/include

.PHONY: all info html pdf clean test main cleanup test-success test-failure

all: info html

info:
	makeinfo $(TEXI_INCLUDE_FLAGS) $(TEXI_SOURCE) -o $(MANUAL).info

html:
	mkdir -p $(MANUAL)_html
	makeinfo --html --no-split $(TEXI_INCLUDE_FLAGS) $(TEXI_SOURCE) -o $(MANUAL)_html/index.html

pdf:
	texi2pdf $(TEXI_INCLUDE_FLAGS) $(TEXI_SOURCE) -o $(MANUAL).pdf

clean:
	rm -rf $(MANUAL).info $(MANUAL).info-* $(MANUAL)_html $(MANUAL).pdf
	rm -f *.aux *.cp *.cps *.fn *.fns *.ky *.kys *.log *.pg *.pgs *.toc *.tp *.tps *.vr *.vrs

test:
	bash test/test.sh
	python3 -m pytest -q modules/lmlmxtend-runtime/reaper

main:
	@echo main
	@test "$(SHOULD_FAIL)" != "1"

cleanup:
	@echo cleanup

-include cleanup.mk

test-success:
	$(call run-with-cleanup,$(MAKE) main,$(MAKE) cleanup)

test-failure:
	$(call run-with-cleanup,SHOULD_FAIL=1 $(MAKE) main,$(MAKE) cleanup)
