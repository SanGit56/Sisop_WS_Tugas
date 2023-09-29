#!/bin/bash

echo "Enter filename : " 
read filename

hour=$(( $(echo 10#$filename | cut -d: -f1) ))

log=$(cat "$filename")

len=${#log}

# ascii
a=97; A=65; z=122; Z=90

for (( i = 0; i < $len; i++ )); do
    char=${log:$i:1}
    num=$(( $(printf "%d" "'$char") - $hour ))

    if [[ "$char" =~ ^[[:lower:]]+$ && $num -lt $a ]]; then
        num=$(($a - num))
        num=$((num % 26))
        num=$(($z - num + 1))
    elif [[ $char =~ ^[[:upper:]]+$ && $num -lt $A ]]; then
        num=$(($A - num))
        num=$((num % 26))
        num=$(($Z - num + 1))
    elif ! [[ $char =~ ^[[:lower:]]+ || $char =~ ^[[:upper:]]+$ ]]; then
        num=$((num + $hour))
    fi

    printf "\x$(printf %x $num)"
done
