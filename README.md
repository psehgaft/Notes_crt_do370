# Notes_crt_do370

```sh
oc annotate storagecluster ocs-storagecluster uninstall.ocs.openshift.io/cleanup-policy="retain" --overwrite
oc annotate storagecluster ocs-storagecluster uninstall.ocs.openshift.io/mode="forced" --overwrite
```

Label nodes for OCP Storage (ODF)

```sh
oc label nodes -l node-role.kubernetes.io/worker=  cluster.ocs.openshift.io/openshift-storage=
```

ODF Validating

```sh
oc get operatorgroups,subscriptions,clusterserviceversions -n openshift-local-storage
watch oc get operatorgroups,subscriptions,clusterserviceversions  -n openshift-storage
oc get localvolumediscovery,localvolumediscoveryresults -n openshift-local-storage

oc get localvolumeset -n openshift-local-storage
oc get storagecluster -n openshift-storage
```



