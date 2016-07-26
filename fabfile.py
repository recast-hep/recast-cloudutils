from fabric.api import *

env.key_filename = '/afs/cern.ch/user/l/lheinric/openstack/openstack.pem'
env.user = 'root'
env.hosts = ['lheinric-recast-dockernode-00{0}'.format(x) for x in [0,1,2,3,5,6]]

def uname():
    run('uname -a')

def cvmfs_probe():
    run('cvmfs_config probe')

def restart():
    run('shutdown -r 10')

def docker_ps():
    run('docker ps')

def resetup_head_ssh(headhost):
    run('ssh-keygen -R {0}'.format(headhost))
    run('ssh-keyscan -t rsa {0} > ~/.ssh/known_hosts'.format(headhost))

def check_auth():
    run('ls /home/recast/recast_auth')

def manual_auth():
    run('cern-get-certificate --autoenroll --grid')
    run('cp /etc/pki/tls/certs/lheinric-*.cern.ch.grid.pem /home/recast/recast_auth/host.cert')
    run('cp /etc/pki/tls/private/lheinric-*.cern.ch.grid.key /home/recast/recast_auth/privkey.pem')

def check_ssh(headhost):
    run('ssh root@{0} "echo ssh ok."'.format(headhost))

def recompose():
    run('curl -O /home/recast/compose.yml https://raw.githubusercontent.com/recast-hep/recast-cloudutils/master/compose_configs/worker_compose.yml')
    run('supervisorctl restart recast_worker')
