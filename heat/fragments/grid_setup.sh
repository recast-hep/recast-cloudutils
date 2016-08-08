#!/bin/sh
source /etc/sysconfig/heat-params

echo "$(date) ::::RECAST:::: grid_setup.sh"


rm -rf /etc/krb5.keytab
attempts=100
while [ ${attempts} -gt 0 ]; do
    sleep 15
    cern-get-keytab
    rc=$?
    echo "return code is: $rc"
    if [ $rc -eq 0 ]; then
        echo "cern-get-keytab succeeded.. moving on"
        break
    fi
    echo "waiting for cern-get-keytab to go through"
    attempts=$((attempts-1))
done

attempts=100
while [ ${attempts} -gt 0 ]; do
    sleep 15
    cern-get-certificate --autoenroll --grid
    rc=$?
    echo "return code is: $rc"
    if [ $rc -eq 0 ]; then
        echo "cern-get-certificate succeeded.. moving on"
        break
    fi
    echo "waiting for cern-get-certificate to go through"
    attempts=$((attempts-1))
done

echo "$(date) ::::RECAST:::: done setting up cern keytab/cert"

echo "$(date) ::::RECAST:::: setting up grid stuff"


mkdir -p /home/recast/recast_auth
cp "/etc/pki/tls/certs/$SERVERNAME.cern.ch.grid.pem" /home/recast/recast_auth/host.cert
cp "/etc/pki/tls/private/$SERVERNAME.cern.ch.grid.key" /home/recast/recast_auth/privkey.pem
chmod 400  /home/recast/recast_auth/privkey.pem


cat << 'EOF_GMP' > /home/recast/recast_auth/getmyproxy.sh
#!/bin/sh
scriptdir=$(dirname $0)

export X509_USER_CERT=$scriptdir/host.cert
export X509_USER_KEY=$scriptdir/privkey.pem

if [ ! $(stat --format=%a "$X509_USER_KEY") -eq 400 ];then
  echo "warning: permissions on private key: $X509_USER_KEY are not correct. should be 400";
  exit 1
fi

source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh
if ! type "voms-proxy-init" > /dev/null;then
localSetupEmi
fi
  
thehostname="$SERVERNAME"
myproxy-logon -l lheinric -k "new_recast_$thehostname" -n --voms atlas
voms-proxy-info --all
EOF_GMP

chmod +x /home/recast/recast_auth/getmyproxy.sh
sed -i 's|$SERVERNAME|'"$SERVERNAME"'|' /home/recast/recast_auth/getmyproxy.sh

echo "$(date) ::::RECAST:::: end grid_setup.sh rc: $?"
