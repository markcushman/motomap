# Use the small IBM java JRE
FROM ibmjava:sfj

# Load our application
COPY mkgmap /motomap/mkgmap
COPY splitter /motomap/splitter
COPY motomap /motomap/motomap
COPY precomp-sea /motomap/precomp-sea

# run motomap
CMD ["/bin/bash", "/motomap/motomap/motomap.sh"]