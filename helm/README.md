#install helm
#https://helm.sh/docs/intro/install/#from-script


helm_install.sh

#!/bin/bash

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

helm version #to get version

helm search hub consul # to search for consul chart on hub
helm search repo [repo_name] # to search locally


helm repo add [name] [url] # to add repo from hub locally
helm repo remove [name] #to remove repo

helm repo list # list local repos

helm install [name] [repo/name]
helm install mze-surf bitnami/apache
helm unistall mze-surf

helm list # list releases

helm upgrade [release_name] [repo/name] --version 13
helm rollback [release_name] 3 #revision number


Test before run

helm lint ./nginx-chart # to check the configuration about mistakes

helm template ./nginx-chart # to see what would be genarated with values from values.yaml
helm template ./nginx-chart --debug # to see details about the issue

helm install test_release ./nginx-chart --dry-run # to get results from kubernetes if there is an issue

helm package ./nginx-chart # to package the chart