.PHONY: all

all: histo.total ndt.total

histo.total: Makefile aggregate.hs histo-div.sh self.sql
	./histo-div.sh
	cat self*.out | /usr/bin/runhaskell aggregate.hs > histo.total

ndt.total: Makefile sumeach.hs ndt-all.sh ndt-bal-drop.sql
	./ndt-all.sh
	cat ndt*.out | /usr/bin/runhaskell sumeach.hs > ndt.total