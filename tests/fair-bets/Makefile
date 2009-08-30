.PHONY: all clean

all: fairBets maximumLikelihood

eig.cmx: eig.ml Makefile
	ocamlfind ocamlopt -package lacaml -c eig.ml

getGraphDirect.cmx: getGraphDirect.ml Makefile
	ocamlfind ocamlopt -package mysql -c getGraphDirect.ml

fairBets: fairBets.ml eig.cmx Makefile
	ocamlfind ocamlopt -package lacaml,ocamlgraph -c fairBets.ml
	ocamlfind ocamlopt -package lacaml,ocamlgraph -linkpkg eig.cmx fairBets.cmx -o fairBets

maximumLikelihood: maximumLikelihood.ml getGraphDirect.cmx Makefile
	ocamlfind ocamlopt -package ocamlgraph,mysql,gsl -c maximumLikelihood.ml
	ocamlfind ocamlopt -package ocamlgraph,mysql,gsl -linkpkg getGraphDirect.cmx maximumLikelihood.cmx -o maximumLikelihood

getGraphDirect.cmo: getGraphDirect.ml Makefile
	ocamlfind ocamlc -package mysql -c getGraphDirect.ml

mletop: getGraphDirect.cmo maximumLikelihood.ml Makefile 
	ocamlfind ocamlmktop -package gsl,ocamlgraph,mysql -linkpkg getGraphDirect.cmo maximumLikelihood.ml -o mletop

clean:
	rm eig.cmx eig.cmi eig.o 
	rm getGraphDirect.cmx getGraphDirect.cmi getGraphDirect.o getGraphDirect.cmo
	rm fairBets.cmx fairBets.o fairBets.cmi fairBets 
	rm maximumLikelihood.cmx maximumLikelihood.o maximumLikelihood.cmi maximumLikelihood maximumLikelihood.cmo