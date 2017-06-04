# recast-cloudutils
cloud provisioning scripts 


## Preparing a Kubernetes Computer Cluster and CephFS storage on OpenStack

Create a Kubernetes Cluster using Magnum

```bash
magnum cluster-create \
--name recast_cluster \
--keypair-id openstack \
--cluster-template kubernetes-preview-yadage \
--node-count 5

mkdir magnum && cd magnum
eval $(magnum cluster-config recast_cluster |tee setup.sh)
```

Create a shared Storage Share via Manila

```bash
manila create --share-type "Geneva CephFS Testing" --name recast_storage cephfs 1000
manila access-allow recast_storage cephx recast_storage_user
```

Note the access key shown by and encode it in b64

```bash
manila access-list recast_storage
printf <access key> |base64 -w 0
```

and create a Kubernetes secret: 

```yaml
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: cephsecret
data:
  key: <your encoded access key>
```


Note the volume path shown under  

```bash
manila show recast_storage
```
and adapt the manifest in storage to use your secrets and manila user.

## Creating a RECAST instance on a Kubernetes Cluster

Create the Storage Resources

```bash
kubectl create -f . --validate=false
```
Create the following secrets

For workflow backend
```
- atlas-auth: for ATLAS VO authentication via KRB and X509
 - getkrb.sh
 - getmyproxy.sh
 - kerberos.keytab
 - gridpw
 - host.cert
 - privkey.pem
- docker_reg_cern: for Docker Registry Authentication (e.g. CERN GitLab)
 - username
 - password
- yadage_load_token: for loading private workflows
 - token
- control-center-ssh: SSH keys for shipping results from workers to persistant storage
 - rsa.key
 - rsa.pub
```


For Web Frontends

Workflow Web Frontend
```
- yadage_webui_auth: for CERN SSO and Bearer authentication to workflow service
 - oauth_secret
 - bearer_token
```

RECAST Control Center
```
- control-center-config: Control Center configuration (including SSO, etc..)
  - config.yaml
- control-center-ssl: Control Center SSL certificates
  - server.crt
  - server.key
```

RECAST Frontend
```
- frontend-ssl: Frontedn SSL certificates
  - server.crt
  - server.key
```
