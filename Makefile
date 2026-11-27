MANUAL = mymanual
DOCDIR = doc
SRC = $(DOCDIR)/$(MANUAL).texi
INCLUDES = -I $(DOCDIR) -I $(DOCDIR)/include

all: info html

info:
	makeinfo $(INCLUDES) $(SRC) -o $(MANUAL).info

html:
	makeinfo --html $(INCLUDES) $(SRC) -o $(MANUAL)_html

pdf:
	texi2pdf $(INCLUDES) $(SRC) -o $(MANUAL).pdf

clean:
	rm -rf $(MANUAL).info* $(MANUAL)_html $(MANUAL).pdf
	rm -f *.aux *.cp *.cps *.fn *.fns *.ky *.log *.pg *.toc *.tp *.vr

.PHONY: all info html pdf clean
