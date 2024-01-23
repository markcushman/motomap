#!/bin/bash
# motomap builder script

# redirect stderr to stdout
set -o errexit
exec 2>&1

# if we are on MacOS then alias the date command to gdate
# install the coreutils package to get this: brew install coreutils

if [[ "$(uname)" == "Darwin"* ]]; then
   date() { gdate "$@"; }
fi

#record our start date/time
startDatetime=$(date)
echo "INFO: Motomap Processing - Started"

# we need two variables, the base directory for the motomap code
# and the path to the configuration file for motomap.sh
# get switches from the command line
# otherwise get the environment variables

if [[ -z "${MOTOMAP_BASEDIR}" && -z "${MOTOMAP_CONFIG}" ]]; then
  echo "INFO: getting options from getopts"
  while getopts ":b:c:" opt; do
    case "${opt}" in
      b)
        echo "INFO: basedir is ${OPTARG}"
        basedir=${OPTARG}
        ;;
      c)
        echo "INFO: config is ${OPTARG}"
        config=${OPTARG}
        ;;
    esac
  done
else
  echo "INFO: using environment variables"
  basedir=$MOTOMAP_BASEDIR
  config=$MOTOMAP_CONFIG
fi

if [[ -z "${basedir}" || -z "${config}" ]]; then
  echo "ERROR: Variables basedir:$basedir and config:$config not set"
  exit 1
fi

# jump into the motomap base dir so we can find all our stuff
cd $basedir
mkdir -p working
source motomap/parse_yaml.sh
eval $(parse_yaml $config)

echo "INFO: Motomap Processing - Config for map: input_file=$inputfile output_file=$outputfile, familyid=$familyid, mapname=$mapname, mapdesc=$mapdesc"

echo "INFO: Motomap Processing - Splitting Map"
# split each pbf file into segments so we don't run out of memory
# allocating max of 4G heap space - create the container with 5G memory
java -Xms$memmin -Xmx$memmax -jar splitter/splitter.jar --output-dir="working/" $inputfile

echo "INFO: Motomap Processing - Generating Map"
# gen the .img file from the split files
java -Xms$memmin -Xmx$memmax -jar mkgmap/mkgmap.jar --mapname="$mapname" --family-id="$familyid" --family-name="Motomap - $mapdesc" --description="Motomap - $mapdesc" --output-dir=working/ --precomp-sea=precomp-sea/sea-latest.zip --generate-sea --route --housenumbers -c motomap/motomap.cfg working/6324*.osm.pbf motomap/typ/motomap_typ.txt
mv working/gmapsupp.img $outputfile

# clean up
rm -rf working

# log end of processing
endDatetime=$(date)
diffSeconds="$(($(date -d "${endDatetime}" +%s)-$(date -d "${startDatetime}" +%s)))"
diffTime=$(date -d @${diffSeconds} +"%Hh %Mm %Ss" -u)
echo "INFO: Motomap Processing - Complete in $diffTime, output file $outputfile"