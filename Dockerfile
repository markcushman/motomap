# Use the small IBM java JRE
FROM ibmjava:sfj

# Load our application
COPY mkgmap /motomap/mkgmap
COPY splitter /motomap/splitter
COPY motomap /motomap/motomap
COPY map001.osm /motomap/map001.osm

# run motomap
CMD ["/bin/bash", "/motomap/motomap/motomap.sh"]