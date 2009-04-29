.PHONY: clean

JudgeSideBias: JudgeSideBias.hs BinomialTest.hs ReadDecPerJudge.hs Makefile
	ghc --make -main-is JudgeSideBias JudgeSideBias.hs

clean: Makefile
	rm *.o *.hi JudgeSideBias*.txt