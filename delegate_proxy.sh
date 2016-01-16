#!/bin/zsh
#usage: delegate_proxy.sh <hostname>
myproxy-init -c 100000 -t 100000 -d -s  myproxy.cern.ch -k new_recast_"$1" -Z $1.cern.ch  -l lheinric
