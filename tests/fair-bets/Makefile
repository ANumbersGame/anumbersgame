.PHONY: all clean

all: fairBets

eig.cmx: eig.ml Makefile
	ocamlfind ocamlopt -package lacaml -c eig.ml

fairBets: fairBets.ml eig.cmx Makefile
	ocamlfind ocamlopt -package lacaml,ocamlgraph -c fairBets.ml
	ocamlfind ocamlopt -package lacaml,ocamlgraph -linkpkg eig.cmx fairBets.cmx -o fairBets

clean:
	rm eig.cmx eig.cmi eig.o fairBets.cmx fairBets.o fairBets.cmi fairBets