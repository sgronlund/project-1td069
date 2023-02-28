#!/usr/bin/bash

url="https://www.ncei.noaa.gov/data/global-hourly/access/"
years=$(seq 2000 2000) #TODO: Maybe parse cmdline args for a span of years and create sequence from that?

# init stage
mkdir -p data

for i in $years; do
    curr_dir="${url}/${i}/"
    wget -e robots=off -U mozilla --show-progress --no-host-directories --no-directories --quiet --random-wait --no-parent -r --reject="index.html*,*.txt" --directory-prefix="data/$i" "$curr_dir"
    #TODO: Maybe add command to put directory onto HDFS here or create separate script for that?
done

total_data_size=$(du -h data | tail -n 1 | awk '{print $1}')

echo "Done downloading, total size of dataset is ${total_data_size}"
