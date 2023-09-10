#!/bin/bash
set -veuo pipefail

# AlertManager container volume mount spec:
oc get statefulset/alertmanager-main \
  -n openshift-monitoring \
  -o jsonpath='{.spec.template.spec.containers}' | \
jq '.[] | select(.name == "alertmanager") | .volumeMounts[] | select(.name == "alertmanager-main-db")'

# AlertManager volume mount type:
oc get statefulset/alertmanager-main \
  -n openshift-monitoring \
  -o jsonpath='{.spec.template.spec.volumes}' | \
  jq '.[] | select(.name == "alertmanager-main-db")'
