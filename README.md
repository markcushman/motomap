# Motomap
A set of mkgmap configuration files and shell scripts to create adventure motorcycle maps for Garmin devices. The style highlights roads that are not paved in blue and smaller roads (called tracks) that are unpaved in red. This configuration works well on a Garmin Zumo XT, untested on any other device. Generages multiple map files (in Garmin .img format) and a style **motomap.kmtf** file that can be dropped into the filesystem of a Garmin device.

To utilize this style:
* make sure you have a working java installation
* create a directory alongside **motomap** called **motomap_work**
* download map data (\*.osm.pbf for the regions you want) from https://download.geofabrik.de/ and place in **motomap_work/**
* edit **motomap.sh** and include paths to these files in the array 
* download mkgmap http://www.mkgmap.org.uk/ and place in a **mkgmap** directory alongside **motomap**
* run **motomap/motomap.sh**
* copy the image files from **motomap_work/\*.img** to your Garmin device in the **/Map** directory
* copy **motomap.kmtf** to your Garmin device in the **/Themes/Map** directory

Right now support only for Latin characters.
Generates maps that looks like these (Garmin Zumo XT):

![Image](https://github.com/markcushman/motomap/blob/master/screenshots/chattahoochee%20nf.png?raw=true)

![Image](https://github.com/markcushman/motomap/blob/master/screenshots/old%20dial%20road.png?raw=true)

![Image](https://github.com/markcushman/motomap/blob/master/screenshots/old%20dial%20road%20zoomed.png?raw=true)

![Image](https://github.com/markcushman/motomap/blob/master/screenshots/85%20and%20400.png?raw=true)
