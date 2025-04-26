# transformers

namespace: my-namespace

commonLabels:
  someName: someValue
  owner: alice
  app: bingo

commonAnnotations:
  oncallPager: 800-555-1212

namePrefix: alices-
nameSuffix: -v2



# image tag change

Example Deployment containers:
- name: mypostgresdb
  image: postgres:8
- name: nginxapp
  image: nginx:1.7.9
- name: myapp
  image: my-demo-app:latest
- name: alpine-app
  image: alpine:3.7

one can change the image in the following ways:
postgres:8 to my-registry/my-postgres:v1,
nginx tag 1.7.9 to 1.8.0,
image name my-demo-app to my-app,
alpine’s tag 3.7 to a digest value

all with the following kustomization:

images:
- name: postgres
  newName: my-registry/my-postgres
  newTag: v1
- name: nginx
  newTag: 1.8.0
- name: my-demo-app
  newName: my-app
- name: alpine
  digest: sha256:24a0c4b4a4c0eb97a1aabb8e29f18e917d05abfe1b7a7c07857230879ce7d3d3