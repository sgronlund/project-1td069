#!/usr/bin/bash

url="https://www.ncei.noaa.gov/data/global-hourly/access/"
years=$(seq 2000 2023)

# init stage
mkdir -p data

for i in $years; do
    curr_dir="${url}/${i}/"
    wget --show-progress --no-host-directories --no-directories --quiet --random-wait --no-parent -r --reject="index.html*,*.txt" --directory-prefix="data/$i" "$curr_dir"
    #TODO: Maybe add command to put directory onto HDFS here or create separate script for that?
done

echo "done"
