#!/bin/bash
# motomap builder script

# create a working directory if it doesn't exist
mkdir -p motomap_work

# TODO download the map from OSM

# gen the .img file
java -jar mkgmap/mkgmap.jar -c motomap/motomap.cfg --input-file=motomap_work/map.osm --output-dir=motomap_work/ motomap/typ/motomap_typ.txt

#clean up
rm -f ovm_6324*.img 6324*.img motomap_work/motomap_typ.typ motomap_work/osmmap.img motomap_work/osmmap.tdb
cp motomap/themes/motomap.kmtf motomap_work/
