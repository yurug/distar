#!/bin/sh

set -u
cd "$(dirname "$0")"

# Code used when the script ends
source "../error.sh"

# Code used when the script ends
error_code=0


# Function to test if the verbose mode prints correct outputs
# $1 source file used by distar
# $2 target file used by distar
# $3 name of .output and .expected files
verbose_mode_test_2 () {

    ../distar -v "$1" "$2" > "$3".output 2>&1 
    
    # Keep diff output to compare in case of error
    output=$(diff -w "$3".output "$3".expected)

    # If there is no difference between the files, diff return 0
    # else it returns 1
    show_and_update_error $1  $output
}


# Test with an existing source and an existing target 
verbose_mode_test_2 "source_1.ml" "target.md" "good_args" 

# Test with wrong target
verbose_mode_test_2 "source_1.ml" "none.md" "bad_target"

# Test with wrong source
verbose_mode_test_2 "none.ml" "target.md" "bad_source"

exit_with_code



