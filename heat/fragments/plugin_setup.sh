#!/bin/sh
source /etc/sysconfig/heat-params
echo "$(date) ::::RECAST:::: start plugin_setup.sh"

docker pull lukasheinrich/recast-cap-demo

echo "$(date) ::::RECAST:::: pulling compose manifest"



HEADNODE="$HEADNODE" SERVERNAME="$SERVERNAME" \
envsubst '$HEADNODE','$SERVERNAME' \
< /etc/recast_provisioning_resources/worker_compose_template.yml >  /home/recast/compose.yml


echo "$(date) ::::RECAST:::: compose template is"
cat /home/recast/compose.yml


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
