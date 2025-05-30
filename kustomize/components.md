├── base
│   ├── deployment.yaml
│   └── kustomization.yaml
├── components
│   ├── external_db
│   │   ├── configmap.yaml
│   │   ├── dbpass.txt
│   │   ├── deployment.yaml
│   │   └── kustomization.yaml
│   ├── ldap
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── kustomization.yaml
│   │   └── ldappass.txt
│   └── recaptcha
│       ├── deployment.yaml
│       ├── kustomization.yaml
│       ├── secret_key.txt
│       └── site_key.txt
└── overlays
    ├── community
    │   └── kustomization.yaml
    ├── dev
    │   └── kustomization.yaml
    └── enterprise
        └── kustomization.yaml

---
components\external_db\kustomization.yaml:

apiVersion: kustomize.config.k8s.io/v1alpha1  # <-- Component notation
kind: Component

secretGenerator:
- name: dbpass
  files:
    - dbpass.txt

patches:
  - path: configmap.yaml

patchesJson6902:
- target:
    group: apps
    version: v1
    kind: Deployment
    name: example
  path: deployment.yaml


---
kustomization.yaml:

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base

components:
  - ../../components/external_db
  - ../../components/recaptcha