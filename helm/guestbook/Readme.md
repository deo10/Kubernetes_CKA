# Installation steps

# adding repo
helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami

# update dependencies (download)
helm dependency update ./guestbook

# check:
ls ./guestbook/charts/

# installing helm - ! no _ symbols in name of the chart
helm install my-guestbook ./guestbook


