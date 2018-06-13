#!/bin/sh
set -uC
cd "$(dirname "$0")"

# Functions for printing
print_error () {
    printf -- "\n|- \033[1;31mFAILED\033[0m\n"
}

print_ok () {
    printf -- "\n|- \033[1;32mOK\033[0m\n"
}

# Functions to calculate stats
success=0
failure=0
total=0

succeed () {
    success=$((success+1))
    total=$((total+1))
}

failed () {
    failure=$((failure+1))
    total=$((total+1))
}

# Add a symbolic link with the executable
ln -s ../src/distar.exe distar

# Roam all the directories to launch test.sh
printf "\n=== Situational tests ===\n\n"
for dir in */
do
     printf -- "--> \033[1;39m%s\033[0m" "$dir"

     # Launch local test 
     "$dir"/test.sh

     # Count sucess and failure
     if [ $? -eq 0 ];then
         succeed 
         print_ok 
     else
         failed 
         print_error 
     fi
     printf "\n" #Add one line between tests
done
printf -- "---------\n"
printf "$success succeed, $failure failed, total : $total\n"

