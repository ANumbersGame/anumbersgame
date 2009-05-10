.PHONY: all

all: histo.total

histo.total: Makefile aggregate.hs histo-div.sh self.sql
	./histo-div.sh
	cat self*.out | /usr/bin/runhaskell aggregate.hs > histo.total