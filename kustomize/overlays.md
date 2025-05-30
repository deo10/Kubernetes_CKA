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


# example of replace image for QA env (JSON option)

bases:
  - ../../base
commonLabels:
  environment: QA

patches:
  - target:
      kind: Deployment
      name: api-deployment
    patch: |-
      - op: replace
        path: /spec/template/spec/containers/0/image
        value: caddy
