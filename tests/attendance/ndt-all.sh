#!/bin/bash

for YEAR in 0506 0607 0708
do
    mysql DebateResults${YEAR} < ndt-bal-drop.sql > ndt${YEAR}.out
done