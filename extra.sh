# Install ODF

oc label nodes -l node-role.kubernetes.io/worker= cluster.ocs.openshift.io/openshift-storage=
# Install Local storage Operator 
# - Create Local Volume Discovery.
# - Create Local Volume Set
# Install OpenShift Container Storage Operator
# - Create StorageCluster

# Exernal registry

oc extract secret/noobaa-registry -n openshift-image-registry
oc create secret generic image-registry-private-configuration-user --from-literal=REGISTRY_STORAGE_S3_ACCESSKEY=".." --from-literal=REGISTRY_STORAGE_S3_SECRETKEY=".." --namespace openshift-image-registry

oc get -n openshift-image-registry objectbucketclaim/noobaa-registry
oc get route/s3 -n openshift-storage

# Edit config/cluster

oc edit configs.imageregistry/cluster 
---
spec:
  storage:
    managementState: Managed
    pvc: null
    s3:
      bucket: noobaa-registry-038ca5ee-d9ed-4b20-997a-c72058af2426
      region: us-east-1
      regionEndpoint: https://s3-openshift-storage.apps.ocp4.example.com
----

# Monitoring

oc edit configmap/cluster-monitoring-config -n openshift-monitoring

---
prometheusK8s:
  retention: 7d
  volumeClaimTemplate:
    spec:
      storageClassName: ocs-storagecluster-ceph-rbd
      resources:
        requests:
          storage: 40Gi
alertmanagerMain:
  volumeClaimTemplate:
    spec:
      storageClassName: ocs-storagecluster-ceph-rbd
      resources:
        requests:
          storage: 20Gi
---

oc create -n openshift-monitoring configmap cluster-monitoring-config --from-file config.yaml=metrics-storage.yml

# Backup

command: 
- 'dnf -qy install rsync && rsync -avH /var/application /backup'
