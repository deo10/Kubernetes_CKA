# patches example

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

patches:
- path: patch.yaml
  target:
    group: apps
    version: v1
    kind: Deployment
    name: deploy.*
    labelSelector: "env=dev"
    annotationSelector: "zone=west"
- patch: |-
    - op: replace
      path: /some/existing/path
      value: new value    
  target:
    kind: MyKind
    labelSelector: "env=dev"


---
# Name and kind changes
resources:
- deployment.yaml
patches:
- path: patch.yaml
  target:
    kind: Deployment
  options:
    allowNameChange: true
    allowKindChange: true

---
# Change the image and add label on deployment level

# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dummy-app
  labels:
    app.kubernetes.io/name: nginx
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: nginx
  template:
    metadata:
      labels:
        app.kubernetes.io/name: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:stable
          ports:
            - name: http
              containerPort: 80


# kustomization.yaml
resources:
- deployment.yaml
patches:
  - patch: |-
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: dummy-app
        labels:
          app.kubernetes.io/version: 1.21.0      
  - patch: |-
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: not-used
      spec:
        template:
          spec:
            containers:
              - name: nginx
                image: nginx:1.21.0      
    target:
      labelSelector: "app.kubernetes.io/name=nginx"

---
# Inline Strategic Merge example
# kustomization.yaml
resources:
- deployment.yaml
patches:
  - path: add-label.patch.yaml
  - path: fix-version.patch.yaml
    target:
      labelSelector: "app.kubernetes.io/name=nginx"

As with the Inline Strategic Merge, the target field can be omitted. In that case, the target resource is matched using the apiVersion, kind and name from the patch.

# add-label.patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dummy-app
  labels:
    app.kubernetes.io/version: 1.21.0

# fix-version.patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: not-used
spec:
  template:
    spec:
      containers:
        - name: nginx
          image: nginx:1.21.0


# remove option

# kustomization.yaml
patches:
- path: patch.yaml
  target:
    group: apps
    version: v1
    kind: Deployment
    name: deploy.*
    labelSelector: "env=dev"
    annotationSelector: "zone=west"
- patch: |-
    - op: remove
      path: /metadata/labels/app.kubernetes.io/version


# remove-label.patch.yaml Inline Strategic Merge
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dummy-app
  labels:
    app.kubernetes.io/version: null


# list of patches (use index value [0..1..2])
# replace
patches:
- path: patch.yaml
  target:
    group: apps
    version: v1
    kind: Deployment
    name: deploy.*
    labelSelector: "env=dev"
    annotationSelector: "zone=west"
- patch: |-
    - op: replace
      path: /spec/template/spec/containers/0 # working with 1st container
      value:
        name: haproxy #change name and image for 1st container in depl
        image: haproxy

# Add operation with list
patches:
- path: patch.yaml
  target:
    group: apps
    version: v1
    kind: Deployment
    name: deploy.*
    labelSelector: "env=dev"
    annotationSelector: "zone=west"
- patch: |-
    - op: replace
      path: /spec/template/spec/containers/- # adding
      value:
        name: haproxy #adding name and image for 1st container in depl
        image: haproxy

# Remove operation with list
patches:
- path: patch.yaml
  target:
    group: apps
    version: v1
    kind: Deployment
    name: deploy.*
    labelSelector: "env=dev"
    annotationSelector: "zone=west"
- patch: |-
    - op: remove
      path: /spec/template/spec/containers/1 # removing 2nd container in depl

# remove-container.patch.yaml Inline Strategic Merge
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deployment
spec:
  template:
    spec:
      containers:
        - $patch: delete
          name: nginx # delete container from depl with the name nginx


# example removing label from deployment
# kustomization.yaml
resources:
  - mongo-depl.yaml
  - api-depl.yaml
  - mongo-service.yaml

patches:
  - target:
      kind: Deployment
      name: mongo-deployment
    patch: |-
      - op: remove
        path: /spec/template/metadata/labels/org