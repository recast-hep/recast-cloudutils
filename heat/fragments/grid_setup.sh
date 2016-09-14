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


SERVERNAME="$SERVERNAME" envsubst < /etc/recast_provisioning_resources/getmyproxy_template.sh > /home/recast/recast_auth/getmyproxy.sh
KRB_PRINCIPAL=lheinric   envsubst < /etc/recast_provisioning_resources/getkrb_template.sh     > /home/recast/recast_auth/getkrb.sh
cat /etc/recast_provisioning_resources/encrypted_secrets/kerberos.keytab.enc | /etc/recast_provisioning_resources/decrypt.sh $RECAST_PROV_PWD > /home/recast/recast_auth/kerberos.keytab
chmod +x /home/recast/recast_auth/getkrb.sh
chmod +x /home/recast/recast_auth/getmyproxy.sh

echo "$(date) ::::RECAST:::: end grid_setup.sh rc: $?"
