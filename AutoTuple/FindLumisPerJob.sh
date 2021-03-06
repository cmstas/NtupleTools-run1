#!/bin/bash

EVT_PER_JOB=30000
NEVENTS="$(./das_client.py --query="dataset= $1 | grep dataset.nevents" | tail -1)"
NLUMIS="$(./das_client.py --query="dataset= $1 | grep dataset.nlumis" | tail -1)"
EVT_PER_LUMI=$(echo "$NEVENTS/$NLUMIS" | bc)
LUMI_PER_JOB=$(echo "$EVT_PER_JOB/$EVT_PER_LUMI" | bc)
echo $LUMI_PER_JOB
