#!/bin/bash

# This is a script to convert MS Access databases in the mdb format to plain text files that MySQL can read.
# It expects that mdbtools is installed.
# Unfortunately, mdbtools appears unmaintained, and does not build from source for me.
# Fedora and Debian both package it.
# The first Google hit is http://mdbtools.sourceforge.net/ , which is essentially empty.
# Some usefule pages can be found, however, at http://mdbtools.sourceforge.net/install/ and http://sourceforge.net/projects/mdbtools


if ! [[ $1 ]]
then
    echo "Usage: $0 FILE outputs a dump of the Microsoft Access Database FILE, in a MySQL-friendly format"
    exit 1
else
    if ! [[ $(file -b $1) = "Microsoft Access Database" ]]
    then
        echo "Warning: $1 does not look like a Microsoft Access Database"
    fi
    readonly OUT=$(mktemp)
    readonly TEMP=$(mktemp)

    mdb-schema $1 mysql >$OUT 
    cat $OUT | sed 's/DROP TABLE/DROP TABLE IF EXISTS/g' >$TEMP
    mv $TEMP $OUT
    #MySQL doesn't like three dashes in a row to start a comment
    cat $OUT | sed s/---/--/g >$TEMP
    while [[ $(diff -u $OUT $TEMP) ]]
    do
        mv $TEMP $OUT
        cat $OUT | sed s/---/--/g >$TEMP
    done

    mv $TEMP $OUT
    #"Div" is not a valid MySQL column name.
    #MS Access's date type is MySQL's DATETIME, but in the wrong order
    cat $OUT | sed s/Div/Diiv/g | sed 's/\tdate/\tVARCHAR(100)/g'
    rm $OUT

    for TABLE in $(mdb-tables $1)
    do
	#The "Div" column name correction will mess up some spelling in judge philosophies.
        mdb-export -I $1 $TABLE | sed s/INSERT/\;\\nINSERT/g | sed s/Div/Diiv/g
        echo \;
    done
fi

# Here is part of a Makefile which builds tables:
#
#all.schema: $(ACCESSDB) Makefile
#        mdb-schema Webtournamentmaster0708.mdb >$@
#
#%.mysql: $(ACCESSDB) Makefile all.schema
#        mdb-export -I $< $* | sed s/INSERT/\;\\nINSERT/g > $@
#        echo \; >> $@
#
#maketables: all.schema $(TABLES) Makefile $(ACCESSDB)
#        mysql cedametrics < all.schema
#        mysql cedametrics < MasterResults.mysql
#        mysql cedametrics < MasterJudges.mysql
#        mysql cedametrics < TeamNumbers.mysql
