#!/bin/bash
# motomap builder script

# if we are on MacOS then alias the date command to gdate
# install coreutils to get this with brew:
# brew install coreutils

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias date=gdate
fi

#record our start date/time
startDatetime=$(date)
echo "INFO: Motomap Processing - Started"

# get variables if they are passed on the command line
# otherwise get the environment variables

if [ $# -eq 0 ]
  then
    input_file=$MOTOMAP_INPUT_FILE
    output_file=$MOTOMAP_OUTPUT_FILE
    mapid=$MOTOMAP_MAPID
    mapdesc=$MOTOMAP_MAPDESC
  else
    input_file=$1
    output_file=$2
    mapid=$3
    mapdesc=$4
fi

# redirect stderr to stdout
set -o errexit
exec 2>&1

# assign unique ids to each map to allow them to coexist
# on the Garmin device, we'll use 16xxx as a base
mapname=$((6324$mapid))

echo "INFO: Motomap Processing - Config for map: input_file=$input_file output_file=$output_file, mapid=$mapid, mapname=$mapname, mapdesc=$mapdesc"

#jump into the motomap base dir
cd /motomap/
mkdir -p /motomap/working

echo "INFO: Motomap Processing - Splitting Map"
# split each pbf file into segments so we don't run out of memory
# allocating max of 4G heap space - create the container with 5G memory
java -Xms4G -Xmx4G -jar splitter/splitter.jar --output-dir="working/" $input_file

echo "INFO: Motomap Processing - Generating Map"
# gen the .img file from the split files
java -Xms4G -Xmx4G -jar mkgmap/mkgmap.jar --mapname="$mapname" --family-id="$mapid" --family-name="Motomap - $mapdesc" --description="Motomap - $mapdesc" --output-dir=working/ -c motomap/motomap.cfg working/6324*.osm.pbf motomap/typ/motomap_typ.txt
mv working/gmapsupp.img $output_file

# log end of processing
endDatetime=$(date)
diffSeconds="$(($(date -d "${endDatetime}" +%s)-$(date -d "${startDatetime}" +%s)))"
diffTime=$(date -d @${diffSeconds} +"%Hh %Mm %Ss" -u)
echo "INFO: Motomap Processing - Complete in $diffTime, output file $output_file"