#!/bin/zsh

if [[ -z "$1" ]];then
  echo "usage: provisionmachine.sh <image> <flavor> <hostname> <queue>"
  exit 0
fi

image=$1
flavor=$2
hostname=$3
queue=$4

echo "OK"

tmpfile=$(mktemp)
cat << EOFOUT > $tmpfile
#!/bin/sh


rm -rf /etc/krb5.keytab
cern-get-keytab
sleep 1000
cern-get-certificate --autoenroll --grid

usermod -aG docker recast


mkdir /home/recast/recast_auth
cp "/etc/pki/tls/certs/$hostname.cern.ch.grid.pem" /home/recast/recast_auth/host.cert
cp "/etc/pki/tls/private/$hostname.cern.ch.grid.key" /home/recast/recast_auth/privkey.pem
chmod 400  /home/recast/recast_auth/privkey.pem


cat << 'EOF_GMP' > /home/recast/recast_auth/getmyproxy.sh
#!/bin/sh
scriptdir=\$(dirname \$0)

export X509_USER_CERT=\$scriptdir/host.cert
export X509_USER_KEY=\$scriptdir/privkey.pem

if [ ! \$(stat --format=%a "\$X509_USER_KEY") -eq 400 ];then
  echo "warning: permissions on private key: \$X509_USER_KEY are not correct. should be 400";
  exit 1
fi

source \${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh
if ! type "voms-proxy-init" > /dev/null;then
localSetupEmi
fi
  
thehostname="$hostname"
myproxy-logon -l lheinric -k "new_recast_\$thehostname" -n --voms atlas
voms-proxy-info --all
EOF_GMP

chmod +x /home/recast/recast_auth/getmyproxy.sh

cd /home/recast
base64 --decode << EOF_ZIP > auth.zip
UEsDBAoAAAAAAM2ijkcAAAAAAAAAAAAAAAAiABwAcmVjYXN0LWF1dGgtcmVzb3VyY2VzX3R3by9k
b3Qtc3NoL1VUCQAD8hZvVvIWb1Z1eAsAAQQ7kAAABBsFAABQSwMEFAAAAAgAzaKOR5LvYsJ/AAAA
pgAAACgAHAByZWNhc3QtYXV0aC1yZXNvdXJjZXNfdHdvL2RvdC1zc2gvY29uZmlnVVQJAAPyFm9W
8hZvVnV4CwABBDuQAAAEGwUAAD2NUQrDMAxD/3sKn2A9Q+nYOvozCDtASEVjZhxI3JbefskY+xG2
npCmVIzKrpeAXCV2RK+CTBLBmjnU/+7c8HwMm0WocfDGSelE+aMrBKs3jBlLi3gpX95NrVxS8BLr
VfPOaqU1e8Y5RoQ360qafquzpkMbLTcWUL9g73UT6T5QSwMEFAAAAAgAzaKOR7FJSDoEBQAAiwYA
ACgAHAByZWNhc3QtYXV0aC1yZXNvdXJjZXNfdHdvL2RvdC1zc2gvaWRfcnNhVVQJAAPyFm9W8hZv
VnV4CwABBDuQAAAEGwUAAG2Vt7KkCgxEc75ic2oLM9gQ72HwJsN7DwPM1+/dt+lTqkCtU2r1798/
xQqSYv5yXObX21ECxhN+aUL8t/EbMBRFmC+FZRiNY2yBAXnpmUceGty35ygy1ti9oPVJWA3wZrvP
u7RuMZNb7eRiFUZxGFiO3b5LuEGyOeTedR09dTpfYUCg5HvZmoDNkO+F3/sXX5SSWd2NeFd02gqr
5780cQiACh8UuWVv3Ui7xbgkzu+Ob/cUEmbrCPw6RQVjb1ZV3bk8UdOJ5kpdNO8QgvorNZNTAEdf
IpcGGvo8euiME4N3r7WVv5BvHUOL32BruauulrFyEn0ZAbSt6faCsX/acikC6gvQsXkjuljSZIWb
bG4d5nm3h1ea2Xe/K4LZPehmlJHv9EBDD+TNvCij42O9RI/efRcZYOtqd743jpweL7Wj4sU/mW6U
he6QieQm7G1t9ucHsnL9gzzfQ6wkzPNDSGVcBQFGn71yDLEeVgwpkSXbaknq/LRCSsBXXuuzNBpz
FLrXzDOWnbx2jG7oZiw4CemwJemAq5KkYXqoVnq+Di5vUbQ4oTBv7kLbSuFYipZaZad5Na3T8CYj
wUxxG9vD3O5QX4R9AVhCDSdy4173mchET2sRwbz+FLZEcXvbrWWShJYibJcgQTyJ6vly1AVwjkG6
vgcG5ICqrjsLj4ibVEafU4q63Qma0uBERFaRwFkT7dOhLi0pRJLK0K4j3id7DFEe/xBZQ8+A7IXc
fs76lDLaFBmkRx+o0PrKTa5wA2I6nSjwNzUUCRk28W2mq3F2TeLQoA1mymfLATMa+/rS2NrmoQ1r
5Bhfq3nJKVCm9z2tkzAemeXt0bAtuBLdhs7o6lyRdFKRf2SR3wDBv+WKGn2BA0EfLpHMZ3PEleea
R02504g2keMQJQpYICPtSs2b6STOQ9XB6oLuo7yAul64j79rr15+fAQCSSspbtl3jHpTeUiKM6er
eHaVIryEsPrM90q40n+KsYoiVWAyYIx7zZsOkx/J0B3/emj9rawOzzs7ZplxPeMJ7nKLPBlQU1Pt
+bhoM+UwYrHBPcBAEPhEIdy2b3QdoV/vSS0o3nWFGGJkuIIs0p+WReALLTBTBs7KmdJGRNeG4JM7
PmzWQExszIm35OrE9KpwFkWX4a17+Ypz9M/VlH5/DpD9V/LPptS+zKiGjijb+ysn8uwBAZJp2njr
hE77lAejkNrboUa7VnMDczbbUdOPSmgksiNgjEcpyp+asBxbvSYLlzlgIwJJGoXGjw+cTJ1WeRQf
gZMfWt1B6Wd2vi6nIBlooukyA6ETrioJiO/6R7gi036kGMQAcJifFvLOLKQrJsyNyNB69C9lGTL2
F9pIzs+jOpymtGGIfCaXUj8maGlqyYsBU1gncKEv4gorzvO9ND8Q69qpM5gkx7bMc0LZMRlab3jH
KfHpShE3GAF1yoaiLPibY1/degNgy3ZSfUSidaPHdvabB2VS/ekGW4pbG2b49eYtdZdquSCtHd6p
uTYT0SbAaieaBsMAinS+zCyxjI4Ma0j0K5LdiVL5HTEOQoy9HnMOXWf7LNz7E9wB9QoWE9LJKmj1
XSHNCBB6zhNhh1vHxS/YkIESqBt9xjI73m0pM+A2rt3YpbPLLN3FfI0Oo3Ew5GUlskqcVwAYDKG1
4YG7OD9g7s1ijRuiWA+hkGLIJ42/2FGcyt4NRBFz3tslM0UE/Bcpgsn/f9T8AVBLAwQUAAAACADN
oo5Haz17/1cBAACWAQAALAAcAHJlY2FzdC1hdXRoLXJlc291cmNlc190d28vZG90LXNzaC9pZF9y
c2EucHViVVQJAAPyFm9W8hZvVnV4CwABBDuQAAAEGwUAAB3HyXKCMACA4XufwrvTkUW0HnpgE4Gw
ScTlxhJ2JZJQEp6+nf6Hb+YnpP4cSbpS/9Jkf0l1keeS+b/2/GdkqmvD4sPT2PRxCM/2aVtHnel2
j2vZC2MU8xAF7JidGnfS744gKQKmJGJIqMVsuOphVd14lQ7zNdlJ+xCPdaJl4jIrjCwKtpH6jsdd
WB7SxnzDi+we+6RUevvUaAx4aYu92dIvLV1aXljbCIiCPB3trcY0x4kHNEn++TaUDnYhNZNqserX
uaAdEmd37YHhCaVB2fWQvasgl8Wlum/wpd6+EXFiN9NOj9uimusoeDGYPDveIFwkX8vh7jMRHNFh
Xyq+lgfUn1hDIfKzhbBypxK4Yar9NFqQuBIVQ1X+8lrjDpBEuzgssgg47RSO+v7FYRrdCtngGfBQ
Ac77hxU/NBaM0c/8/b0aUZ4S+on7qWpeKzxlfZOvOsQ/fgFQSwECHgMKAAAAAADNoo5HAAAAAAAA
AAAAAAAAIgAYAAAAAAAAABAA7UEAAAAAcmVjYXN0LWF1dGgtcmVzb3VyY2VzX3R3by9kb3Qtc3No
L1VUBQAD8hZvVnV4CwABBDuQAAAEGwUAAFBLAQIeAxQAAAAIAM2ijkeS72LCfwAAAKYAAAAoABgA
AAAAAAEAAACkgVwAAAByZWNhc3QtYXV0aC1yZXNvdXJjZXNfdHdvL2RvdC1zc2gvY29uZmlnVVQF
AAPyFm9WdXgLAAEEO5AAAAQbBQAAUEsBAh4DFAAAAAgAzaKOR7FJSDoEBQAAiwYAACgAGAAAAAAA
AQAAAICBPQEAAHJlY2FzdC1hdXRoLXJlc291cmNlc190d28vZG90LXNzaC9pZF9yc2FVVAUAA/IW
b1Z1eAsAAQQ7kAAABBsFAABQSwECHgMUAAAACADNoo5Haz17/1cBAACWAQAALAAYAAAAAAABAAAA
pIGjBgAAcmVjYXN0LWF1dGgtcmVzb3VyY2VzX3R3by9kb3Qtc3NoL2lkX3JzYS5wdWJVVAUAA/IW
b1Z1eAsAAQQ7kAAABBsFAABQSwUGAAAAAAQABAC2AQAAYAgAAAAA
EOF_ZIP

unzip auth.zip
cp /home/recast/recast-auth-resources_two/dot-ssh/* /root/.ssh

# remove the host key for recast-demo from the known host file
if [ -e ~/.ssh/known_hosts ];then
	ssh-keygen -R recast-demo
	ssh-keygen -R svn.cern.ch
fi

# add a fresh host key

ssh-keyscan -t rsa recast-demo >> ~/.ssh/known_hosts
ssh-keyscan -t rsa svn.cern.ch >> ~/.ssh/known_hosts


cat << EOF_USER_DATA > /home/recast/user_data.sh
#!/bin/zsh
export RECAST_PLUGINHOMEDIR=code
export RECAST_QUEUE=$queue
export RECAST_SHIP_USER=analysis
export RECAST_SHIP_HOST=localhost
export RECAST_SHIP_PORT=2022
export CELERY_REDIS_HOST=localhost
export CELERY_REDIS_PORT=6379
export CELERY_REDIS_DB=0
export CAP_USER=lukas
export CAP_ACCESSKEY=YXNkbmZrbGFqbmZsawo=
export CAP_HOST='https://pseudo-cap.herokuapp.com'
EOF_USER_DATA

#update code
(cd /home/recast/code/recast_plugin && git pull)


EOFOUT

print OK

echo "::::wrote user_data to $tmpfile"

openstack server create --image $image --flavor $flavor --key-name openstack --user-data $tmpfile $hostname --property landb-os=linux --property landb-osversion='Centos'
