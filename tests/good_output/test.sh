#!/bin/sh

###########################################
#             Test - distar               #
#           Copyright (C) 2018            #
#   Yann Régis-Gianas - Étienne Marais    #
###########################################


##  Test if the simple output is good

# Program output
output=$(./distar good_output/source.ml good_output/target.html)
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
