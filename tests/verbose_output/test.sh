#!/bin/sh

set -u
cd "$(dirname "$0")"


# Function to test if the verbose mode prints correct outputs
verbose_mode_test () {
    
    # Launch distar in verbose mode and store output in a file
    if [ $1 -eq 1 ] ; then
        ../distar -v "$2" "$3" > "$4".output
    else
        ../distar -v "$2" "$3" 2> "$4".output
    fi
    
    # Keep diff output to compare in case of error
    output=$(diff "$4".output "$4".expected)

    # If there is no difference between the files, diff return 0
    # else it returns 1
    if [ $? -eq 0 ];  then
        printf "\nTest $4 - OK"    
    else
        echo "\n"$output
        exit 1
    fi
}



# Test with good arguments
verbose_mode_test 1 "source_1.ml" "target.md" "good_args" 

# Test with wrong target
verbose_mode_test 2 "source_1.ml" "none.md" "bad_target"

# Test with wrong source
verbose_mode_test 2 "none.ml" "target.md" "bad_source"





