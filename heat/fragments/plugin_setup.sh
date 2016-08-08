#!/bin/sh
source /etc/sysconfig/heat-params
echo "$(date) ::::RECAST:::: start plugin_setup.sh"

docker pull lukasheinrich/recast-cap-demo

echo "$(date) ::::RECAST:::: pulling compose manifest"
curl -o /home/recast/compose.yml https://raw.githubusercontent.com/recast-hep/recast-cloudutils/master/compose_configs/worker_compose.yml

cd /home/recast
mkdir -p /home/recast/workdirsdata
mkdir -p /home/recast/quarantinedata
cat << STARTNEWOUT > /home/recast/startcompose.sh
#!/bin/sh
cd /home/recast
export RECAST_IN_DOCKER_QUARANTINE_VOL=/home/recast/quarantinedata
export RECAST_IN_DOCKER_WORKDIRS_VOL=/home/recast/workdirsdata
export RECAST_QUEUE=$QUEUE
docker-compose -f compose.yml up 
STARTNEWOUT
chmod +x startcompose.sh
echo "$(date) ::::RECAST:::: end of plugin_setup.sh rc: $?"
