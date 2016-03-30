#!/bin/zsh
set -e
#set -x

if [[ -z "$1" ]];then
  echo "usage: provisionmachine.sh <flavor> <hostname>"
  exit 0
fi

image='CC7 Extra - x86_64 [2015-06-12]'
flavor=$1
hostname=$2

worker_pubkey=$(cat workerkey.pub)

tmpfile=$(mktemp)
cat << EOFOUT > $tmpfile
#!/bin/sh

echo "\$(date) ::::RECAST:::: setting up headnode"

curl -fsSL https://get.docker.com/ | sh
chkconfig docker on
service docker start
docker pull lukasheinrich/recast-backend
docker pull redis
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
echo $worker_pubkey >> ~/.ssh/authorized_keys 

echo "\$(date) ::::RECAST:::: done setting up headnode"

EOFOUT

echo "::::wrote user_data to $tmpfile"
openstack server create --image $image --flavor $flavor --key-name openstack --user-data $tmpfile $hostname --property landb-os=linux --property landb-osversion='Centos'
