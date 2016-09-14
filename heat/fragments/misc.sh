#!/bin/sh
source /etc/sysconfig/heat-params
echo "::::RECAST::::$(date):::: start of user data"
echo "::::RECAST::::$(date):::: server is: $SERVERNAME"

usermod -aG docker recast

echo "::::RECAST::::$(date):::: configuring diamond"
curl https://raw.githubusercontent.com/recast-hep/recast-cloudutils/master/config_files/diamond.conf > /etc/diamond/diamond.conf
sed -i 's|__RECAST_MONITOR_HOST__|'"$HEADNODE"'|' /etc/diamond/diamond.conf


echo "::::RECAST::::$(date):::: getting provisioning resources"
cd /etc
wget https://github.com/recast-hep/recast-cloudutils/archive/master.zip -O tmprecast.zip
unzip tmprecast.zip
rm tmprecast.zip
mv recast-cloudutils-master/heat/provisioning_resources recast_provisioning_resources

echo "::::RECAST::::$(date):::: end of user data rc: $?"
