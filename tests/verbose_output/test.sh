#!/bin/sh

set -u
cd "$(dirname "$0")"

## If verbose works

# Launch distar in verbose mode and store output in a file
../distar -v source_1.ml source_2.ml target.md > test.output

# Keep diff output to compare in case of error
output=$(diff test.output test.expected)

# Check diff exit code
if [ $? -eq 0 ]
then
    printf "\nGood output - OK"
else
    echo $output
    exit 1
fi


## If verbose fails

# Target doesn't exist
../distar -v source_1.ml source_2.ml none.md 2> error.output

output=$(diff error.output error.expected)

# Check diff exit code
if [ $? -eq 0 ]
then
    printf "\nBad target - OK"
else
    printf $output
    exit 1
fi

# Source doesn't exist
../distar -v none.ml target.md 2> source.output
output=$(diff source.output source.expected)

# Check diff exit code
if [ $? -eq 0 ]
then
    printf "\nBad source - OK "
else
    printf -- "\n"$output
    exit 1
fi




