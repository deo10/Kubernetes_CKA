# Installation steps

# adding repo
helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami

# update dependencies (download)
helm dependency update ./guestbook

# check:
ls ./guestbook/charts/

# installing helm - ! no _ symbols in name of the chart
helm install my-guestbook ./guestbook


---
Option with kodekloud
# run Helm playground

# clone repo
from https://github.com/PacktPublishing/Managing-Kubernetes-Resources-using-Helm/tree/main

# adding repo
helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami

# update dependencies (download)
helm dependency update chapter7/guestbook







