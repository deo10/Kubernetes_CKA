pages 361 - 385
# Publishing to a Helm Chart Repository

check dependecies:
-> helm dependency update chapter8/guestbook

create tgz archive:
-> helm package guestbook chapter8/guestbook
a file called guestbook-0.1.0.tgz will be created.

copy archive to the Git repo folder then:
-> helm repo index <GitHub Pages repository clone>

see the new index.yaml:

apiVersion: v1
entries:
  guestbook:
  - apiVersion: v2
    appVersion: v5
    created: "2022-02-20T04:13:36.052015-05:00"
    dependencies:
    - condition: redis.enabled
      name: redis
      repository: https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
      version: 15.5.x
    description: An application used for keeping a running record of guests
    digest: 983dee22d05be37fb73cf6a06fa5a2b2c320c1678ad6a8 df3d198a403f467343
    name: guestbook
    type: application
    urls:
    - guestbook-0.1.0.tgz
    version: 0.1.0
generated: "2022-02-20T04:13:36.045492-05:00"

then push the changes on Git Repo...

add new helm repo to be able to install charts from it
-> helm repo add example <GitHub Pages Site URL>

-> helm search repo guestbook


Questions
Answer the following questions to test your knowledge of this chapter:
1. What are three different tools you can use to create an HTTP repository?


2. What command can you run to ensure that dependencies are always
included in the .tgz archive?
check dependecies:
-> helm dependency update chapter8/guestbook

3. What files are required when publishing to an HTTP server?
.tgz
index.yaml
