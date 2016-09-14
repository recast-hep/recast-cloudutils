#!/bin/bash
scriptdir=$(dirname $0)
kinit ${KRB_PRINCIPAL}@CERN.CH -k -t $scriptdir/kerberos.keytab
