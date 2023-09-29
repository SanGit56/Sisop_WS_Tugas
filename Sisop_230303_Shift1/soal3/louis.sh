#!/bin/bash

# pembuat : Kelompok C11

# Meminta input dari user
echo "Enter username : "
read username
echo "$username">>users.txt

# Mengecek apakah username sudah terdaftar
if grep -q "^$username:" users.txt; 
then
  echo "Username already exist"
  echo "$(date +"%y/%m/%d %H:%M:%S") Register: ERROR User already exist">>log.txt
  exit 1
fi

# Meminta input password dari user
echo "Enter password :"
read -s password

# Memeriksa apakah password memenuhi syarat
invalid_pass() {
    echo "Invalid password"
    exit 1
}

if  [[ ${#password} -lt 8 ]]; then
    invalid_pass
fi

if ! [[ "$password" =~ [[:lower:]] ]]; then
    invalid_pass
fi

if ! [[ "$password" =~ [[:upper:]] ]]; then
    invalid_pass
fi

if ! [[ "$password" =~ [0-9] ]]; then
    invalid_pass
fi

if [[ $password =~ chicken ]]; then
    invalid_pass
fi

if [[ $password =~ ernie ]]; then
    invalid_pass
fi

if [[ $password =~ $username ]]; then
    invalid_pass
fi

echo "password valid!"

# Menambahkan username dan password ke dalam file users.txt
echo "$username:$password" >> users.txt
echo "Registered Successfully"
echo "$(date +"%y/%m/%d %H:%M:%S") REGISTER: INFO User $username registered successfully">>log.txt
