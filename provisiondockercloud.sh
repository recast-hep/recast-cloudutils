#!/bin/sh

if [[ -z "$1" ]];then
  echo "usage: provisioncloud.sh <image> <flavor> <queue> <number>"
  exit 0
fi

image=$1
flavor=$2
queue=$3
number=$4

for x in `seq -f "%03g" 0 "$number"`;do
  hostname=lheinric-recast-dockernode-"$x"
  ./provisiondockerhost.sh $image $flavor $hostname $queue && ./delegate_proxy.sh $hostname
done
