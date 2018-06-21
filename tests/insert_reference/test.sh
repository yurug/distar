#!/bin/sh

set -u
cd "$(dirname "$0")"
progdir="../../bin/"

# Code used when the script ends
source "../error.sh"


# Verify the differences between two files and 
compare_file () {
    output=$(diff -w $1 $2)
    show_and_update_error $1 $output
}

# Execute distar command with an existing source and an existing target.
# The target contains a portion of code from the source.
"$progdir"/distar --track source.ml target.html > insert_reference.output 2>&1


# Verify if the program stdout prints the right message
compare_file insert_reference.output insert_reference.expected

# Verify if distar has inserted a reference to source.ml in target.html
compare_file target.html target.html.expected

exit_with_code
#exit $error_code
