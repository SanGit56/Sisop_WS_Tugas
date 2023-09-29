#!/bin/bash

function_name="$1"

Download() {
    dir=$(pwd)
    number_of_download=$(date +%H)

    # ? jika jam menunjukkan angka 00 maka diganti menjadi 1
    if [[ "${number_of_download}" -eq "00" ]]; then
        number_of_download="1"
    fi

    # ? jika awalan jam adalah "0" (contoh : "09") maka dihapus awalannya
    if [[ "${number_of_download:0:1}" -eq "0" ]]; then
        number_of_download=${number_of_download:1:1}
    fi

    file_name="perjalanan"
    file_num=1

    # ? ngitung berapa folder "kumpulan_"
    batch_name="kumpulan"
    batch_num=$(find "$dir" -maxdepth 1 -type d -name "${batch_name}_*" | wc -l | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    dir_file="${dir}/${batch_name}_$((batch_num + 1))"
    mkdir -p "${dir_file}"

    keyword="indonesia"
    base_url="https://source.unsplash.com/random/800x600/?${keyword}"
    html=""
    
    # ? menyimpan html dari url ke dalam var "html"
    for ((i = 1; i <= $(expr $number_of_download); i++)); do
        html+=$(curl -s "$base_url")
        sleep 1 # ! di-pause 1s biar gambarnya gk sama
    done

    image_urls=$(echo "$html" | grep -Eo 'https://[^"]+"' | sed 's/"$//')

    # ? buat ngecheck apakah isinya udah bener:
    #    echo "$html" > "hasil curl (html).txt"
    #    echo "$image_urls" > "urls.txt"

    # ? buat nge-download image-nya
    for ((i = 0; i < $(expr $number_of_download); i++)); do
        wget -qO "${dir_file}/${file_name}_$((file_num + $i)).jpg" "$(echo "$image_urls" | sed -n "$((i + 1))p")"
    done
}

Zip() {
    dir=$(pwd)
    
    # ? ngitung berapa file zip "devil_"
    zip_name="devil"
    zip_num=$(find "$dir" -maxdepth 1 -type f -name "${zip_name}_*.zip" | wc -l | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    # ? mendapatkan semua folder "kumpulan_"
    batch_name="kumpulan"
    batch_num=$(find "$dir" -maxdepth 1 -type d -name "${batch_name}_*" | wc -l | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    if [[ $batch_num -eq 0 ]]; then
        exit 1
    fi

    # ? find batch folder > hanya mengambil nama foldernya > menjadikan 1 line
    batch_list=$(find "$dir" -maxdepth 1 -type d -name "${batch_name}_*")
    batch_list=$(echo "$batch_list" | sed 's/ /\\ /g')

    # ? -9rmq -> -9: kompresi terbesar, -rm: menghapus file setelah di-zip, -q: melakukan zip tanpa prompts
    echo "$batch_list" | xargs zip -9rmq "${dir}/${zip_name}_$((zip_num + 1)).zip"
}

# ? cek fungsi mana yang mau di-run
if [[ "$function_name" == "Download" ]]; then
    Download
elif [[ "$function_name" == "Zip" ]]; then
    Zip
fi


# setting cron job
# step-step:
    # $ crontab -e
    # * */10 * * * {/home...}/kobeni_liburan.sh; Download
    # * * */1 * * {/home...}/kobeni_liburan.sh; Zip