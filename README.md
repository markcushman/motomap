# Motomap
A set of mkgmap configuration files to create adventure motorcycle maps for Garmin devices. The style highlights roads that are not paved in blue and smaller roads (called tracks) that are unpaved in red. This configuration works well on a Garmin Zumo XT, untested on any other device. Generages a map file **gpsmapsupp.img** and a style **motomap.kmtf** file that can be dropped into the filesystem of a Garmin device.

To utilize this style:
* make sure you have a working java installation
* create a directory alongside **motomap** called **motomap_work**
* download map data from https://www.openstreetmap.org/ and place in **motomap_work/map.osm**
* download mkgmap http://www.mkgmap.org.uk/ and place in a **mkgmap** directory alongside **motomap**
* run **motomap/motomap.sh**
* copy gpsmapsupp.img to your Garmin device in the **/Map** directory
* copy motomap.kmtf to your Garmin device in the **/Themes/Map** directory

Generates a map that looks like this (Garmin Zumo XT):

![Image](https://github.com/markcushman/motomap/blob/master/screenshots/chattahoochee%20national%20forest.png?raw=true)
