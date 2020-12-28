#!/bin/bash
# motomap builder script

# first create a working directory if it doesn't exist
mkdir -p motomap_work
mkdir -p motomap_work/logs

fileext=$(date +'%Y-%m-%d_%H-%M-%S')
# redirect all output
set -o errexit
readonly LOG_FILE="motomap_work/logs/motomap_${fileext}.log"
touch $LOG_FILE
exec 1>$LOG_FILE
exec 2>&1

# define the maps you want to download and build
# we are using the directory structure for Geofabrik
# to both build the map and our directory structure:

# https://download.geofabrik.de/{map}-latest.osm.pbf

map[0]="north-america/us-georgia"
#map[0]="north-america/us-northeast"
#map[1]="north-america/us-south"
#map[2]="north-america/us-midwest"
#map[3]="north-america/us-west"
#map[4]="north-america/us-pacific"
#map[5]="north-america/canada"
#map[6]="north-america/mexico"

# assign unique ids to each map to allow them to coexist
# on the Garmin device

mapid[0]="16009"
#mapid[0]="16010"
#mapid[1]="16020"
#mapid[2]="16030"
#mapid[3]="16040"
#mapid[4]="16050"
#mapid[5]="16060"
#mapid[5]="16070"

# TODO optional download the map from OSM

for i in "${!map[@]}"
do
  # split out the path into dir/mapname
  IFS='/' read -ra path <<< "${map[$i]}"

  # give a unique mapname (8 digit number) so each map can coexist on one Garmin device
  mapname=$((63241600+i))

  # start processing
  echo "*** BEGIN processing directory ${map[$i]} with mapname $mapname ***"

  # split each pbf file into segments so we don't run out of memory
  java -jar splitter/splitter.jar --output-dir="motomap_work/" "motomap_work/${map[$i]}-latest.osm.pbf"

  # gen the .img file from the split files
  java -Xmx4096m -jar mkgmap/mkgmap.jar --mapname="$mapname" --family-id="${mapid[$i]}" --family-name="Motomap ${path[1]}" --description="Motomap ${path[1]}" --output-dir=motomap_work/ -c motomap/motomap.cfg motomap_work/6324*.osm.pbf motomap/typ/motomap_typ.txt

  # rename the output file
  mv motomap_work/gmapsupp.img "motomap_work/${path[0]}/motomap-${path[1]}.img"

  #clean up
  rm -f motomap_work/ovm_6324*.img motomap_work/6324*.img
  rm -f motomap_work/6324*.pbf
  rm -f motomap_work/motomap_typ.typ motomap_work/osmmap.img motomap_work/osmmap.tdb
  rm -f motomap_work/template.args motomap_work/areas.poly motomap_work/areas.list motomap_work/densities-out.txt

  #cp motomap/themes/motomap.kmtf motomap_work/
  echo "*** FINISHED processing directory ${map[$i]} ***"
done
