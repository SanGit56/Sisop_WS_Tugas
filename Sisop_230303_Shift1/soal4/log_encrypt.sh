#!/bin/bash

log_name=$(date +"%H:%M %d:%m:%Y")

hour=$(( $(echo 10#$log_name | cut -d: -f1) ))

log=$(cat /var/log/syslog)

len=${#log}

# ascii
a=97; A=65; z=122; Z=90

for ((i = 0; i < $len; i++)); do
    char=${log:$i:1}
    num=$(( $(printf "%d" "'$char") + $hour ))

    if [[ "$char" =~ ^[[:lower:]]+$ && $num -gt $z ]]; then
        num=$((num % $z))
        num=$((num + $a - 1))
    elif [[ $char =~ ^[[:upper:]]+$ && $num -gt $Z ]]; then
        num=$((num % $Z))
        num=$((num + $A - 1))
    elif ! [[ $char =~ ^[[:lower:]]+ || $char =~ ^^[[:upper:]]+$ ]]; then
        num=$((num - $hour))
    fi

    printf "\x$(printf %x $num)" >> "${log_name}.txt"
done

# tinggal setting cron job setiap 2 jam
# step-step:
#     crontab -e
#     * */2 * * * {/home...}/log_encrypt.sh
