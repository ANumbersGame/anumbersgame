sccSizes: sccSizes.ml winsGraph.ml readWinMatrix.ml Makefile
	ocamlc graph.cma winsGraph.ml readWinMatrix.ml sccSizes.ml -o sccSizes

sccPic: sccPic.ml winsGraph.ml readWinMatrix.ml Makefile clearLosers.ml
	ocamlc graph.cma winsGraph.ml readWinMatrix.ml clearLosers.ml sccPic.ml -o sccPic

winsGraph: winsGraph.ml Makefile
	ocamlc graph.cma winsGraph.ml -o winsGraph
