# Notes_crt_do370

```sh
oc annotate storagecluster ocs-storagecluster uninstall.ocs.openshift.io/cleanup-policy="retain" --overwrite
oc annotate storagecluster ocs-storagecluster uninstall.ocs.openshift.io/mode="forced" --overwrite
```

Label nodes for OCP Storage (ODF)

```sh
oc get nodes -l node-role.kubernetes.io/worker=
```

```sh
oc label nodes -l node-role.kubernetes.io/worker=  cluster.ocs.openshift.io/openshift-storage=
```

Create the openshift-local-storage.

```sh
oc adm new-project openshift-local-storage

oc project openshift-local-storage
```

Label namespaces for monitoring

```sh
oc label namespace/openshift-storage openshift.io/cluster-monitoring=
```

List the disks available in one of the worker nodes.
 - The disk /dev/vda has the operating system installed.
 - The disks /dev/vdb and /dev/vdc are available.

```sh
oc debug node/worker01 -- lsblk --paths --nodeps
```

ODF Validating 

```sh

oc get localvolumediscoveryresults -n openshift-local-storage

oc get all -n openshift-local-storage

oc get localvolumeset -n openshift-local-storage
oc get operatorgroups,subscriptions,clusterserviceversions -n openshift-local-storage
oc get localvolumediscovery,localvolumediscoveryresults -n openshift-local-storage


oc get all -n openshift-storage

watch oc get operatorgroups,subscriptions,clusterserviceversions  -n openshift-storage
oc get storagecluster -n openshift-storage
oc get storageclasses -o custom-columns='NAME:metadata.name,PROVISIONER:provisioner'


```



