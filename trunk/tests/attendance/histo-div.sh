#!/bin/bash

for YEAR in 0304 0405 0506 0607 0708
do
    mysql DebateResults${YEAR} < self.sql > self${YEAR}.out
done