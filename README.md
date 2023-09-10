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

Create the openshift-storage.

```sh
oc adm new-project openshift-storage

oc project openshift-storage
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

ODF Validating openshift-storage.noobaa.io storage class

```sh
oc get storageclasses -o name
```

# Registry

Create Object Bucket Claim


```sh
oc apply -f ObjectBucketClaim-registry.yml

oc get objectbucketclaim/noobaa-review -n openshift-image-registry
```
Create a new generic secret containing for OBC

```sh
oc get secrets -l app=noobaa -n openshift-image-registry

oc extract secret/noobaa-registry -n openshift-image-registry

oc create secret generic image-registry-private-configuration-user --from-literal=REGISTRY_STORAGE_S3_ACCESSKEY=myaccesskey --from-literal=REGISTRY_STORAGE_S3_SECRETKEY=mysecretkey --namespace openshift-image-registry

# oc create secret generic image-registry-private-configuration-user --from-literal=KEY1=value1 --from-literal=KEY2=value2 --namespace openshift-image-registry
```

Identify the bucket name associated with the noobaa-registry OBC

```sh
oc get -n openshift-image-registry objectbucketclaim/noobaa-registry -o jsonpath='{.spec.bucketName}{"\n"}'
```

Identify the URL for the s3 route in the openshift-storage namespace

```sh
oc get route/s3 -n openshift-storage -o jsonpath='{.spec.host}{"\n"}'
```

Apply a patch to the image registry configuration.

```sh
oc patch configs.imageregistry/cluster --type=merge --patch-file=imageregistry-patch.yaml
```

Getting image registry storage type

```sh
oc get deployment/image-registry -n openshift-image-registry -o jsonpath='{.spec.template.spec.containers[*].env}' | jq -r '.[] | select(.name == "REGISTRY_STORAGE") | [.name , .value] | @tsv'
```

Retrieving image registry S3 storage parameters

```sh
oc get deployment/image-registry -n openshift-image-registry -o jsonpath='{.spec.template.spec.containers[*].env}' | jq -r '.[] | select(.name | startswith("REGISTRY_STORAGE_S3")) | [.name , .value] | @tsv'
```

```sh
oc new-project services-registry
```

# Monitoring

Verify the disk space in the emptyDir volume mounted in /prometheus.

```sh
oc exec -n openshift-monitoring statefulset/prometheus-k8s -c prometheus -- df -h /prometheus

oc exec -n openshift-monitoring statefulset/alertmanager-main -c alertmanager -- df -h /alertmanager
```

Create Config Map

```sh
oc create -n openshift-monitoring configmap cluster-monitoring-config --from-file config.yaml=metrics-storage.yml
```

Verify that the prometheus-k8s stateful set in the openshift-monitoring namespace mounts a block device to the /prometheus mount point

```sh
oc exec -n openshift-monitoring statefulset/prometheus-k8s -c prometheus -- df -h /prometheus
oc exec -n openshift-monitoring statefulset/alertmanager-main -c alertmanager -- df -h /alertmanager
```
