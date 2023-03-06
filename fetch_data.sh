#!/usr/bin/bash

url="https://www.ncei.noaa.gov/data/global-hourly/access/"
year_start=2000
year_end=2023
years=$(seq $year_start $year_end) #TODO: Maybe parse cmdline args for a span of years and create sequence from that?

# init stage
mkdir -p data

for i in $years; do
    curr_dir="${url}/${i}/"
    echo "Fetching all files for year $i"
    files=$(mech-dump --link $curr_dir | grep .csv)
    j=1
    for file in $files; do
      wget -e robots=off -U mozilla --no-clobber --no-host-directories --no-directories --quiet --random-wait --no-parent --reject="index.html*,*.txt" --directory-prefix="data/$i" "$curr_dir/$file"
      printf "Downloaded file $j/${#files} \r"
      j=$((++j))
      if [[ $j -eq 50 ]] 
      then
        break
      fi
    done
    printf "\n"
#TODO: Maybe add command to put directory onto HDFS here or create separate script for that?
done

#python3 src/preprocess.py  "data/"


total_data_size=$(du -h data | tail -n 1 | awk '{print $1}')

echo "Done downloading, total size of dataset is ${total_data_size}"
