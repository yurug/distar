# Error to know the exit code (default 0)
error_code=0

# Print test outcome and change or not error code
# $1 Name of the test
# $2 Output of the test
show_and_update_error () {
    if [ $? -eq 0 ] ; then
        printf "|- Test %s - OK\n" "$1"
    else
        error_code=1
        printf "|- Error \n%s\n" "$2" 
    fi      
}

# Exit with the error_code
exit_with_code () {
    exit "$error_code"
}