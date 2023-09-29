#!/bin/bash

# pembuat : Kelompok C11

# Meminta input dari user
echo "Enter username : "
read username

# Mengecek apakah username ada atau tidak
if grep -q "^$username:" users.txt; 
then
  read -s -p "Enter password: " password
else
 echo "Invalid username"
fi
 
# Ambil password dari file users.txt untuk username yang diberikan
stored_password=$(grep "^$username:" users.txt | cut -d: -f2)
 if [[ "$password" == "$stored_password" ]]; then
  echo "$(date +"%y/%m/%d %H:%M:%S") LOGIN: INFO User $username logged in" >> log.txt
  echo -e "\nUser $username logged in"
else
  echo "$(date +"%y/%m/%d %H:%M:%S") LOGIN: ERROR Failed login attempt on user $username" >> log.txt
  echo -e "\nFailed login attempt"
 fi