#!/bin/sh

if [[ -z "$1" ]];then
  echo "usage: provisioncloud.sh <image> <flavor> <queue> <number> <headnode>"
  exit 0
fi

image=$1
flavor=$2
queue=$3
number=$4
headnode=$5

for x in `seq -f "%03g" 0 "$number"`;do
  hostname=lheinric-recast-dockernode-"$x"
  ./provisiondockerized.sh $image $flavor $hostname $queue $headnode && ./delegate_proxy.sh $hostname
done
