#!/bin/sh

set -u
cd "$(dirname "$0")"

# Code used when the script ends
error_code=0


# Verify the differences between two files and 
compare_file () {
    output=$(diff -w $1 $2)
    if [ $? -eq 0 ]; then
        printf "Test $1 - OK\n"
    else
        printf "|-Error\n%s\n" "$output"
        error_code=1
    fi
}

# Execute distar command with an existing source and an existing target.
# The target contains a portion of code from the source.
../distar --track source.ml target.html > insert_reference.output 2>&1



# Verify if the program stdout prints the right message
compare_file insert_reference.output insert_reference.expected

# Verify if distar has inserted a reference to source.ml in target.html
compare_file target.html target.html.expected

exit $error_code
