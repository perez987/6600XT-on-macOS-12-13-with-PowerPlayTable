#!/bin/bash

#█▀ █▄█ █▀▀ █░█ █▀▀ █░█
#▄█ ░█░ █▄▄ █▀█ ██▄ ▀▄▀

#Author: <Anton Sychev> (anton at sychev dot xyz) 
#win-reg-dump-TXT-to-hex-dsl.sh (c) 2023 
#Created:  2023-11-22 23:29:47 
#Desc: Convert pp_table to hex dsl format just simply run and copy and paste

thefile="./extracted.pp_table"

if [[ ! -e "$thefile" ]]; then
    echo "The $thefile file no exist\nPut your PPT Table file in same folder and run this script again."
    exit 1
fi

file_size=$(stat -f %z "$thefile")

printf "\t\t\"PP_PhmSoftPowerPlayTable\",\n\t\tBuffer ()\n\t\t{\n" "$file_size"

while IFS= read -r line; do
    if [[ $line =~ ^0000([0-9A-Za-z]+):\ (([0-9A-Z]{2}\ )+)(\ +)(.*) ]]; then
        o=${BASH_REMATCH[1]}
        b=${BASH_REMATCH[2]}
        s=${BASH_REMATCH[4]}
        c=${BASH_REMATCH[5]}
        
        if [[ ${#b} -lt 34 ]]; then
            b=$(echo "$b" | sed 's/.. /0x&, /g')
            b=${b%??}
        else
            b=$(echo "$b" | sed 's/.. /0x&, /g')
        fi

        s=$(echo "$s" | sed 's/   /      /g')
        
        printf "\t\t\t/* %s */  %s// %s\n" "$(echo "$o" | tr 'a-f' 'A-F')" "$b" "$c"
    fi
done < <(xxd -u -g 1 < "$thefile")

printf "\t\t}\n"