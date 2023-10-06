
# Exernal registry

oc extract secret/noobaa-registry -n openshift-image-registry
oc create secret generic image-registry-private-configuration-user --from-literal=REGISTRY_STORAGE_S3_ACCESSKEY=myaccesskey --from-literal=REGISTRY_STORAGE_S3_SECRETKEY=mysecretkey --namespace openshift-image-registry


# Edit config/cluster

spec:
  storage:
    managementState: Managed
    pvc: null
    s3:
      bucket: noobaa-registry-038ca5ee-d9ed-4b20-997a-c72058af2426
      region: us-east-1
      regionEndpoint: https://s3-openshift-storage.apps.ocp4.example.com
