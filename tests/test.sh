###########################################
#             Test - distar               #
#           Copyright (C) 2018            #
#   Yann Régis-Gianas - Étienne Marais    #
###########################################

#!/bin/sh

# Functions for printing
print_error () {
    echo -e "- \033[1;31mFAILED\033[0m $1"
}

print_ok () {
    echo -e "- \033[1;32mOK\033[0m $1"
}

# Functions to calculate stats
succes=0
failure=0
total=0

succeed () {
    success=$((succes+1))
    total=$((total+1))
}

failed () {
    failure=$((failure+1))
    total=$((total+1))
}


# Roam all the directories to launch test.sh
echo -e "\n=== Situational tests ===\n"
for dir in */
do
     echo -e "--> \033[1;39m$dir\033[0m"

     # Launch local test 
     sh $dir/test.sh

     # Count sucess and failure
     if [ $? -eq 0 ];then
         succeed
         print_ok 
     else
         failed
         print_error 
     fi
     echo -e #Add one line between tests
done
echo "---------"
echo "$success succeed, $failure failed, total : $total"

