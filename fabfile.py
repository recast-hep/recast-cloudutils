from fabric.api import *

env.key_filename = '/afs/cern.ch/user/l/lheinric/openstack/openstack.pem'
env.user = 'root'
env.hosts = ['lheinric-recast-dockernode-00{0}'.format(x) for x in [0,1,2,3,4]]

def uname():
    run('uname -a')

def cvmfs_probe():
    run('echo $hostname && cvmfs_config probe')

def restart():
    run('shutdown -r now')

def docker_ps():
    run('docker ps')
