# install kustomize
it's part of kubectl now, so you can use it directly with kubectl commands.

# kustomize folder structure
   someapp/
   ├── base/
   │   ├── kustomization.yaml
   │   ├── deployment.yaml
   │   ├── configMap.yaml
   │   └── service.yaml
   └── overlays/
      ├── production/
      │   └── kustomization.yaml
      │   ├── replica_count.yaml
      └── staging/
          ├── kustomization.yaml
          └── cpu_count.yaml

# kustomization.yaml file
someapp/base/kustomization.yaml:

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

commonLabels:
    app: hello
resources:
- deployment.yaml
- configMap.yaml
- service.yaml

someapp/overlays/production/kustomization.yaml:

commonLabels:
  env: production
bases:
- ../../base
patches:
- replica_count.yaml

This kustomization specifies a patch file replica_count.yaml, which could be:

apiVersion: apps/v1
kind: Deployment
metadata:
    name: the-deployment
spec:
    replicas: 100

# command to apply kustomization
kustomize build someapp/ # to apply kustomization

kustomize build someapp/ | kubectl apply -f - #to apply kustomization and deploy resources

kustomize build someapp/ | kubectl delete -f - #to delete all resources




