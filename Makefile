SUBDIRS=mincho1 mincho3 mincho5 mincho7 mincho9
DOWNLOADABLES=dump.tar.gz
GENERATABLES=dump_newest_only.txt glyphs.txt \
cidpua.map cidpua-blockelem.map cidpua-dingbats.map \
cidalias.txt cidalias.sed groups/cidalias.txt \
cidalias1.txt cidalias2.txt $(SUBDIRS)
TARGETS=$(GENERATABLES) $(DOWNLOADABLES)

.PHONY: all fetch clean distclean $(SUBDIRS)
all: $(TARGETS)

fetch: $(DOWNLOADABLES)

dump.tar.gz:
	wget -O $@ http://glyphwiki.org/dump.tar.gz

dump_newest_only.txt: dump.tar.gz
	tar xfz $< $@ && touch $@

cidalias1.txt: pua-addenda.txt
	./cidpua.rb < $< > $@
cidalias2.txt: dump_newest_only.txt
	cat $^ | ./cidalias.rb > $@
cidalias.txt: cidalias1.txt cidalias2.txt
	cat $^ > $@

groups/cidalias.txt: cidalias.txt
	cat $^ | cut -f 1 > $@

cidalias.sed: cidalias.txt
	cat $^ | ./cidalias_sed.rb > $@

glyphs.txt: groups/cidalias.txt
	cat $^ | sort | uniq > $@

cidpua.map:
	./mkcfinfo.rb > $@
cidpua-blockelem.map:
	./mkcfinfo.rb BlockElem > $@
cidpua-dingbats.map:
	./mkcfinfo.rb Dingbats > $@

mincho1/Makefile: dump_newest_only.txt glyphs.txt cidalias.sed \
cidpua.map cidpua-blockelem.map cidpua-dingbats.map
	mkdir -p mincho1
	./mkmkfile.rb mincho1.otf 1 "HZ Mincho" "Light" "HZ 明朝" "細" ../cidalias.sed > $@
mincho1: mincho1/Makefile mincho3/work.otf
	cd $@ && make
mincho3/Makefile: dump_newest_only.txt glyphs.txt cidalias.sed \
cidpua.map cidpua-blockelem.map cidpua-dingbats.map
	mkdir -p mincho3
	./mkmkfile.rb mincho3.otf 3 "HZ Mincho" "Book" "HZ 明朝" "標準" ../cidalias.sed > $@
mincho3: mincho3/Makefile
	cd $@ && make
mincho3/work.otf: mincho3
	cd mincho3 && make work.otf
mincho5/Makefile: dump_newest_only.txt glyphs.txt cidalias.sed \
cidpua.map cidpua-blockelem.map cidpua-dingbats.map
	mkdir -p mincho5
	./mkmkfile.rb mincho5.otf 105 "HZ Mincho" "Demi" "HZ 明朝" "中太" ../cidalias.sed > $@
mincho5: mincho5/Makefile mincho3/work.otf
	cd $@ && make
mincho7/Makefile: dump_newest_only.txt glyphs.txt cidalias.sed \
cidpua.map cidpua-blockelem.map cidpua-dingbats.map
	mkdir -p mincho7
	./mkmkfile.rb mincho7.otf 107 "HZ Mincho" "Bold" "HZ 明朝" "太" ../cidalias.sed > $@
mincho7: mincho7/Makefile mincho3/work.otf
	cd $@ && make
mincho9/Makefile: dump_newest_only.txt glyphs.txt cidalias.sed \
cidpua.map cidpua-blockelem.map cidpua-dingbats.map
	mkdir -p mincho9
	./mkmkfile.rb mincho9.otf 109 "HZ Mincho" "Extra" "HZ 明朝" "極太" ../cidalias.sed > $@
	cd $@ && make

clean:
	-rm -rf $(GENERATABLES)

distclean:
	-rm -rf $(TARGETS)
