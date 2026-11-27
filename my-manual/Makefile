MANUAL := mymanual-legacy
SRC := mymanual.texi
INCLUDES := -I . -I include

.PHONY: all info html pdf clean

all: info html

info:
	makeinfo $(INCLUDES) $(SRC) -o $(MANUAL).info

html:
	mkdir -p $(MANUAL)_html
	makeinfo --html --no-split $(INCLUDES) $(SRC) -o $(MANUAL)_html/index.html

pdf:
	texi2pdf $(INCLUDES) $(SRC) -o $(MANUAL).pdf

clean:
	rm -rf $(MANUAL).info $(MANUAL).info-* $(MANUAL)_html $(MANUAL).pdf
	rm -f *.aux *.cp *.cps *.fn *.fns *.ky *.kys *.log *.pg *.pgs *.toc *.tp *.tps *.vr *.vrs

