kubectl create -f https://download.elastic.co/downloads/eck/3.0.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/3.0.0/operator.yaml
kubectl get -n elastic-system pods


helm repo add elastic https://helm.elastic.co
helm repo update
helm install elastic-operator elastic/eck-operator -n elastic-system --create-namespace

cat <<EOF | kubectl apply -f -
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: quickstart
spec:
  version: 8.16.1
  nodeSets:
  - name: default
    count: 1
    config:
      node.store.allow_mmap: false
EOF

