#!/bin/sh
source /etc/sysconfig/heat-params
echo "::::RECAST::::$(date):::: start of user data"
echo "::::RECAST::::$(date):::: server is: $SERVERNAME"

usermod -aG docker recast

echo "::::RECAST::::$(date):::: configuring diamond"
curl https://raw.githubusercontent.com/recast-hep/recast-cloudutils/master/config_files/diamond.conf > /etc/diamond/diamond.conf
sed -i 's|__RECAST_MONITOR_HOST__|'"$HEADNODE"'|' /etc/diamond/diamond.conf

#service diamond restart
echo "::::RECAST::::$(date):::: end of user data rc: $?"
