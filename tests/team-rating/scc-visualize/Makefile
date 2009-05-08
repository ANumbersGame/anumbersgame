.PHONY: all

all: cleanName sccPic

cleanName: cleanName.hs Makefile
	ghc cleanName.hs -o cleanName

sccPic: sccPic.ml ../winsGraph.ml ../readWinMatrix.ml Makefile
	ocamlc graph.cma -I .. ../winsGraph.ml ../readWinMatrix.ml sccPic.ml -o sccPic

charts.zip: Makefile DebateResults*/*.png
	zip -r charts DebateResults*/*.png