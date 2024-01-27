#!/usr/bin/env bash

set -evo pipefail

export IPFS_PATH=$PWD

while true
do

  Rscript --vanilla all-stats.R
  
  ipfs --api $IPFS_API_ADDR pin remote rm --service=pinata --name=marlowestat-all --force || true
  ipfs --api $IPFS_API_ADDR add --quieter --pin=false --recursive=true all > marlowe-all.cid
  ipfs --api $IPFS_API_ADDR pin remote add --service=pinata --name=marlowestat-all $(cat marlowe-all.cid) || true
  ipfs --api $IPFS_API_ADDR name publish --key=marlowestat-all --lifetime=20m $(cat marlowe-all.cid)
  
  Rscript --vanilla external-stats.R
  
  ipfs --api $IPFS_API_ADDR pin remote rm --service=$IPFS_SERVICE --name=marlowestat-ext --force || true
  ipfs --api $IPFS_API_ADDR add --quieter --pin=false --recursive=true ext > marlowe-ext.cid
  ipfs --api $IPFS_API_ADDR pin remote add --service=$IPFS_SERVICE --name=marlowestat-ext $(cat marlowe-ext.cid) || true
  ipfs --api $IPFS_API_ADDR name publish --key=marlowestat-ext --lifetime=20m $(cat marlowe-ext.cid)

  sleep 15m

done
