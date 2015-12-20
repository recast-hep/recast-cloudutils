#!/bin/sh

if [[ -z "$1" ]];then
  echo "usage: provisioncloud.sh <image> <flavor> <queue>"
  exit 0
fi

image=$1
flavor=$2
queue=$3

for x in `seq -f "%03g" 0 25`;do
  hostname=lheinric-recastnode-"$x"
  ./provisionmachine.sh $image $flavor $hostname $queue
  ./delegate_proxy.sh $hostname
done
