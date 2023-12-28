# Motomap
A set of mkgmap configuration files and shell scripts to create adventure motorcycle maps for Garmin devices. The style uses OpenStreetMap data to highlight roads that have been marked as unpaved in blue and smaller roads (called tracks) that are marked as unpaved in red. This configuration works well on a Garmin Zumo XT, untested on any other device. Generages multiple map files (in Garmin **\*.img** format) and a style **motomap.kmtf** file that can be dropped into the filesystem of a Garmin device.

## Pre-Built Maps
If you are looking for pre-built maps to download, you can find US/Canada maps at http://motomap.org/

## Usage
* make sure you have a working java installation
* create a directory alongside **motomap** called **motomap_work**
* download desired map data (\*.osm.pbf) from https://download.geofabrik.de/
* place map data files (\*.osm.pbf) in **motomap_work/**
* edit **motomap.sh** to include paths to the map data files
* download **mkgmap** http://www.mkgmap.org.uk/ and place in a **mkgmap** directory alongside **motomap**
* download **splitter** http://www.mkgmap.org.uk/ and place in a **splitter** directory alongside **motomap**
* run **motomap/motomap.sh**
* copy the image files from **motomap_work/\*.img** to your Garmin device in the **/Map** directory
* copy **motomap.kmtf** to your Garmin device in the **/Themes/Map** directory

## Example
Downloaded three map data files from GeoFabrik download server, created the directory **motomap_work/north-america/** and copied the map data files there with the paths below:
```
motomap_work/north-america/us-northeast-latest.osm.pbf
motomap_work/north-america/us-south-latest.osm.pbf
motomap_work/north-america/us-midwest-latest.osm.pbf
```
Edited **motomap.sh** to include these files (exclude -latest.osm.pbf from the array) and assigned unique map ids (these are somewhat arbitrary, just keep them unique) to keep them separate in the map selection menu of the Garmin device:
``` bash
map[0]="north-america/us-northeast"
map[1]="north-america/us-south"
map[2]="north-america/us-midwest"
mapid[0]="16010"
mapid[1]="16020"
mapid[2]="16030"
```
Ran the command **motomap/motomap.sh** and went to make a cup of coffee - this will take a bit of time.  The script splits the **\*.osm.pbf** files into smaller chunks to process, then builds **\*.img** files from those chunks with the final output:
```
motomap_work/north-america/motomap-us-northeast.img
motomap_work/north-america/motomap-us-south.img
motomap_work/north-america/motomap-us-midwest.img
```
Connect your Garmin device and copy the **\*.img** files above into **/Map**, restart the Garmin device.

## Limitations
* supports only for Latin characters
* very large maps are buggy and may not display fully
* still need to tweak what displays at each zoom level
* setting detail to "More" on GPS may slow map rendering in complex areas

## Screenshots
Generated from a Garmin Zumo XT

![Image](https://github.com/markcushman/motomap/blob/main/screenshots/chattahoochee%20nf.png?raw=true)

![Image](https://github.com/markcushman/motomap/blob/main/screenshots/old%20dial%20road.png?raw=true)

![Image](https://github.com/markcushman/motomap/blob/main/screenshots/old%20dial%20road%20zoomed.png?raw=true)

![Image](https://github.com/markcushman/motomap/blob/main/screenshots/85%20and%20400.png?raw=true)

## Updating maps
Did you find a dirt road that isn't shown in blue/red on the map?  This can be fixed by editing OpenStreetMap at http://openstreetmap.org/ which is the ultimate source for the map data.  You will have to become a contributor (sign up for a login), then:
* Locate the road you want to update
* Edit the road, specifically the **surface** tag
* Valid road surfaces listed here: https://wiki.openstreetmap.org/wiki/Key:surface
* Upload your changes to OpenStreetMap
* Wait approximately 2 hours for the maps to update on the GeoFabrik download server
* Re-download the maps and re-generate the Garmin **\*.img** files

I made a YouTube video that explains this process in detail: https://www.youtube.com/watch?v=L6S9UUMdVdg

## Searching for dirt roads/tracks
A great resource to query OpenStreetMap data for certain features is https://overpass-turbo.eu/.  This website allows you to query for features on the map that have certain attributes.  The query I have been using to find dirt roads while developing the Motomap style is:
```
[timeout:25][bbox:{{bbox}}];
(
  way[highway][highway!~"service|footway|path|cycleway|bridleway"][access!~"private|no"][motor_vehicle!~"no|private"][surface~"unpaved|gravel|dirt|unsurfaced|earth|compacted|fine_gravel|mud|sand|ground"];
);
out body;
>;
out skel qt;
```
This will show all roads within the viwing window that are not commonly private roads or restricted for vehicle access, and also have a surface that is unpaved.
