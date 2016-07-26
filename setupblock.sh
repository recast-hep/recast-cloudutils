#!/bin/bash
pvcreate /dev/vdc
vgcreate vg-docker /dev/vdc
lvcreate -L 90G -n data vg-docker
lvcreate -L 4G -n metadata vg-docker
#service docker stop
rm -rf /var/lib/docker/
#service docker start
