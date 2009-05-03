#!/bin/bash

for DB in 0304 0405 0506 0607 0708
do
    NICE=$(echo $DB | sed s/0/-200/g)
    NICE=${NICE:1}
    echo $NICE
    QUERY=(mktemp)
    cat >$QUERY <<EOF
USE DebateResults${DB};

SELECT ID as ''
FROM MasterTournaments;
EOF
    NUMS=$(mysql < $QUERY);
    for NUM in $NUMS
    do
	./oneTournament.sh DebateResults${DB} $NUM $NICE
    done
done