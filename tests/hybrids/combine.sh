#!/bin/bash

for foo in 0*.out; do
    echo ================$foo===============
    cat $foo
done