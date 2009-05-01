fairBets: fairBets.ml eig.ml ../clearLosers.ml ../readWinMatrix.ml Makefile
#	ocamlc -I /usr/lib/ocaml/lacaml bigarray.cma lacaml.cma -c eig.ml 
	ocamlc -I /usr/lib/ocaml/lacaml bigarray.cma lacaml.cma -I .. -g ../clearLosers.ml ../readWinMatrix.ml eig.ml fairBets.ml -o fairBets

eig: eig.ml Makefile
	ocamlc -I /usr/lib/ocaml/lacaml bigarray.cma lacaml.cma eig.ml -o eig


