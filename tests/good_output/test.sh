#!/bin/sh

set -euC
cd "$(dirname "$0")"

# Program output
output=$(../distar source.ml target.html)
expected="Ok"

# Ouput Test
if [ "$output" = "$expected" ]
then
    exit 0
else
    echo -e "Ouput:\n$output"
    echo -e "Expected:\n$expected"
    exit 127
fi
