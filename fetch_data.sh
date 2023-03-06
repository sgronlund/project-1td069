#!/usr/bin/bash
DEBUG=false
while true;do
  case "$1" in 
    --debug) DEBUG=true; shift ;;
    *) break;;
  esac
done

url="https://www.ncei.noaa.gov/data/global-hourly/access/"
year_start=2000
year_end=2023

header="STATION,DATE,SOURCE,LATITUDE,LONGITUDE,ELEVATION,NAME,REPORT_TYPE,CALL_SIGN,QUALITY_CONTROL,WND,CIG,VIS,TMP,DEW,SLP,AA1,AY1,AY2,GA1,GF1,KA1,MA1,MD1,MW1,OA1,OA2,SA1,UA1,REM,EQD"

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
      if [[ "$DEBUG" == true ]] && [[ $j -eq 51 ]];
      then
        break
      fi
    done
    printf "\n"
#TODO: Maybe add command to put directory onto HDFS here or create separate script for that?
done


shopt -s extglob #enble globbing in script
# start merging files
for dir in $(ls data/); do
  echo $header >> data/$dir/merge.csv
  tail -q -n +2 data/$dir/+([0-9]).csv >> data/$dir/merge.csv
  rm data/$dir/+([0-9]).csv # remove all merged files
done

python3 src/preprocess.py  "$year_start" "$year_end"

total_data_size=$(du -h data | tail -n 1 | awk '{print $1}')

echo "Done downloading, total size of dataset is ${total_data_size}"
