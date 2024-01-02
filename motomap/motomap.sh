#!/bin/bash
# motomap builder script

# get variables if they are passed on the command line
# otherwise get the environment variables

if [ $# -eq 0 ]
  then
    input_file=$MOTOMAP_INPUT_FILE
    output_file=$MOTOMAP_OUTPUT_FILE
    mapid=$MOTOMAP_MAPID
  else
    input_file=$1
    output_file=$2
    mapid=$3
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

echo "input_file = $input_file"
echo "output_file = $output_file"
echo "mapid = $mapid"
echo "mapname = $mapname"

mv $input_file "moved$input_file"
touch $output_file

# split each pbf file into segments so we don't run out of memory
#java -jar splitter/splitter.jar --output-dir="motomap_work/" "motomap_work/${map[$i]}-latest.osm.pbf"

# gen the .img file from the split files
#java -Xmx4096m -jar mkgmap/mkgmap.jar --mapname="$mapname" --family-id="${mapid[$i]}" --family-name="Motomap ${path[1]}" --description="Motomap ${path[1]}" --output-dir=motomap_work/ -c motomap/motomap.cfg motomap_work/6324*.osm.pbf motomap/typ/motomap_typ.txt

# rename the output file
#mv motomap_work/gmapsupp.img "motomap_work/${path[0]}/motomap-${path[1]}.img"

#clean up
#rm -f motomap_work/ovm_6324*.img motomap_work/6324*.img
#rm -f motomap_work/6324*.pbf
#rm -f motomap_work/motomap_typ.typ motomap_work/osmmap.img motomap_work/osmmap.tdb
#rm -f motomap_work/template.args motomap_work/areas.poly motomap_work/areas.list motomap_work/densities-out.txt

#cp motomap/themes/motomap.kmtf motomap_work/
echo "INFO: Motomap Processing Finished"

