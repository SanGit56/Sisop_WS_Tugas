#!/bin/bash

file_csv="../2023 QS World University Rankings.csv"

echo '===== 5 universitas teratas di Jepang ====='
awk -F ',' '/Japan/ {print $1","$2}' "${file_csv}" | head -n 5 | awk -F ',' '{print $2}'
echo -e

echo '===== Universitas dengan fsr score terendah dari 5 universitas teratas di Jepang ====='
awk -F ',' '/Japan/ {print $2","$9}' "${file_csv}" | head -n 5 | sort -k2 -n -t ',' | head -n 1 | awk -F ',' '{print $1}'
echo -e

echo '===== 10 universitas dengan ger rank tertinggi ====='
awk -F ',' '/Japan/ {print $2","$20}' "${file_csv}" | sort -k2 -rn -t ',' | head -n 10 | awk -F ',' '{print $1}'
echo -e

echo '===== Universitas keren di dunia ====='
awk -F ',' '{print $2}' "${file_csv}" | grep 'Keren'
