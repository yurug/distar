#!/bin/sh

set -eu
cd "$(dirname "$0")"

# Launch distar in verbose mode and store output in a file
../distar -v source_1.ml source_2.ml target.md > test.output

# Keep diff output to compare in case of error
output=$(diff test.output test.expected)

# Check diff exit code
if [ $? -eq 0 ]
then
    exit 0
else
    echo $output
    exit 1
fi
