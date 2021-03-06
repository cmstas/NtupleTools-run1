#!/bin/bash

if (( $# != 6 )); then
    echo "Illegal number of arguments."
    return 1
fi

HOME=`pwd`

configFile=$1
libCMS3=$2
GLOBAL_TAG=$3
INPUT_FILE_NAME=$4
OUTPUT_DIR=$5
OUTPUT_FILE_NAME=$6

#Tell us where we're running
echo "host: `hostname`" 

#untar tarball containing CMS3 libraries and python files
echo "libCMS3 = $libCMS3"
if [ -e $libCMS3 ]
then
  tar -xzvf $libCMS3
else
  echo "libCMS3 missing!"
  exit 1
fi

#Set environment
export CMS_PATH=/cvmfs/cms.cern.ch
export SCRAM_ARCH=slc6_amd64_gcc481
source /cvmfs/cms.cern.ch/cmsset_default.sh
source /cvmfs/cms.cern.ch/slc6_amd64_gcc481/lcg/root/5.34.18/bin/thisroot.sh

pushd .
cd /cvmfs/cms.cern.ch/slc6_amd64_gcc481/cms/cmssw/CMSSW_7_2_0/src/
eval `scramv1 runtime -sh`
popd

#The lib and python directories come from the libCMS3 tarball
export LD_LIBRARY_PATH=$PWD/lib/slc6_amd64_gcc481:$LD_LIBRARY_PATH
export PATH=$PWD:$PATH
export PYTHONPATH=$PWD/python:$PYTHONPATH

#INPUT_FILE_NAME_ESCAPED=`echo $INPUT_FILE_NAME | sed 's,/,\\\/,g'

sed -i "s/SUPPLY_GLOBAL_TAG/${GLOBAL_TAG}/g" $configFile
sed -i "s,SUPPLY_INPUT_FILE_NAME,${INPUT_FILE_NAME},g" $configFile
sed -i "s/SUPPLY_OUTPUT_FILE_NAME/${OUTPUT_FILE_NAME}/g" $configFile

echo "ls -lrth"
ls -lrth

#Run it
cmsRun $configFile

echo "ls -lrth"
ls -lrth

#Copy the output
lcg-cp -b -D srmv2 --vo cms --connect-timeout 2400 --verbose file://`pwd`/${OUTPUT_FILE_NAME} srm://bsrm-3.t2.ucsd.edu:8443/srm/v2/server?SFN=${OUTPUT_DIR}/${OUTPUT_FILE_NAME}
