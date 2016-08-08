#!/bin/sh
source /etc/sysconfig/heat-params
echo "::::RECAST::::$(date):::: start of docker_blockdevice_setup.sh"

size=$VOLSIZE
metadatasize=5
datasize=$(echo $VOLSIZE-$metadatasize-1|bc)

echo "::::RECAST::::$(date):::: setting up on block device of size $VOLSIZE"
echo "::::RECAST::::$(date):::: metadata size: $metadatasize"
echo "::::RECAST::::$(date):::: data size: $datasize"

pvcreate /dev/vdb
vgcreate vg-docker /dev/vdb
lvcreate -L "$datasize"G -n data vg-docker
lvcreate -L "$metadatasize"G -n metadata vg-docker
service docker stop
rm -rf /var/lib/docker/
service docker start


echo "::::RECAST::::$(date):::: end of docker_blockdevice_setup.sh rc: $?"
