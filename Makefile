DRAFTS =	draft-ietf-rmcat-gcc-00.txt \
			draft-ietf-rmcat-gcc-00.html \
			draft-ietf-rmcat-gcc-00.pdf
CMDSEP = ;
#VERSION = 00 

all: $(DRAFTS)

%.txt: %.xml
	@echo "generate $< -> $@"
	@echo xml2rfc $< -f $@ --text
	@xml2rfc $< -f $@ --text

	@egrep -ns --colour "\\bmust|required|shall|should|recommended|may|optional\\b" $< || true

%.html: %.xml
	@echo "generate $< -> $@"
	@echo xml2rfc $< -f $@ --html
	@xml2rfc $< -f $@ --html

%.pdf: %.txt
	@echo "enscript $< -> $@"
	@enscript -q -lc -f Courier11 -M A4 -p - $< | ps2pdf - $@

%.2up.pdf: %.txt
	@echo "enscript $< -> $@"
	@enscript -q -2lrc -M A4 -p - $< | ps2pdf - $@

clean:
	-rm -f $(DRAFTS)

copy:
	@version=$(shell if [ -z $(VERSION) ] ; then read -p "version: " REPLY ; echo $$REPLY ; fi ); \
	$(foreach var,$(DRAFTS), cp $(var) $(subst .,-$${version}., $(var))$(CMDSEP))

deploy: all copy clean
