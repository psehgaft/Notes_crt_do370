#!/bin/bash
set -veuo pipefail

# Prometheus container volume mount spec:
oc get statefulset/prometheus-k8s \
  -n openshift-monitoring \
  -o jsonpath='{.spec.template.spec.containers}' | \
jq '.[] | select(.name == "prometheus") | .volumeMounts[] | select(.name == "prometheus-k8s-db")'

# Prometheus volume mount type:
oc get statefulset/prometheus-k8s \
  -n openshift-monitoring \
  -o jsonpath='{.spec.template.spec.volumes}' | \
  jq '.[] | select(.name == "prometheus-k8s-db")'
