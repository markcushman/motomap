#!/bin/bash
# motomap builder script

#export MOTOMAP_INPUT_FILE=/motomap/map001.osm
#export MOTOMAP_OUTPUT_FILE=/motomap/map001.img
#export MOTOMAP_MAPID=0001
#export MOTOMAP_MAPDESC="Small Home"

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

# fileext=$(date +'%Y-%m-%d_%H-%M-%S')

# redirect stderr to stdout
set -o errexit
exec 2>&1

# define the maps you want to download and build
# we are using the directory structure for Geofabrik
# to both build the map and our directory structure:
# https://download.geofabrik.de/{map}-latest.osm.pbf

# assign unique ids to each map to allow them to coexist
# on the Garmin device, we'll use 16xxx as a base

mapname=$((6324$mapid))

echo "INFO: Motomap Processing Started"

echo "INFO: input_file = $input_file"
echo "INFO: output_file = $output_file"
echo "INFO: mapid = $mapid"
echo "INFO: mapname = $mapname"
echo "INFO: mapdesc = $mapdesc"

#jump into the motomap base dir
cd /motomap/
mkdir -p /motomap/working

echo "INFO: Motomap Processing - Splitting Map"
# split each pbf file into segments so we don't run out of memory
java -Xmx1024m -jar splitter/splitter.jar --output-dir="working/" $input_file

echo "INFO: Motomap Processing - Generating Map"
# gen the .img file from the split files
java -Xmx1024m -jar mkgmap/mkgmap.jar --mapname="$mapname" --family-id="$mapid" --family-name="Motomap - $mapdesc" --description="Motomap - $mapdesc" --output-dir=working/ -c motomap/motomap.cfg working/6324*.osm.pbf motomap/typ/motomap_typ.txt

# rename the output file
mv working/gmapsupp.img $output_file

#clean up
#rm -f working/ovm_6324*.img working/6324*.img
#rm -f working/6324*.pbf
#rm -f working/motomap_typ.typ working/osmmap.img working/osmmap.tdb
#rm -f working/template.args working/areas.poly working/areas.list working/densities-out.txt

#cp motomap/themes/motomap.kmtf working/
echo "INFO: Motomap Processing Finished"
echo "INFO: Listing Directory Contents"
ls -al /motomap/