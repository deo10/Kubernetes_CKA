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

default path(s)
$HOME/.cache/helm
$HOME/.config/helm

helm search hub consul # to search for consul chart on hub
helm search repo [chart_name] --versions # to search on added repo


helm repo add [name] [url] # to add repo from hub locally
helm repo remove [name] #to remove repo

helm pull [name] [url] #to download chart as tar archive

helm repo list # list local repos

show
helm show chart bitnami/wordpress --version 12.1.6 #Display the chart’s metadata (or chart definition)
helm show readme bitnami/wordpress --version 12.1.6 #Display the chart’s README file
helm show values bitnami/wordpress --version 12.1.6 #Display the Chart.yaml content
helm show all bitnami/wordpress --version 12.1.6 #Display the chart’s definition, README files, and values

helm install [name] [repo/name]
helm install mze-surf bitnami/apache
helm unistall mze-surf

helm list # list releases

helm get hooks # To return all the hooks for a named release
helm get manifest # To return the manifest (yaml) for a named release
helm get notes # To return the notes for a named release
helm get values # To return the values for a named release
helm get all # To return all the information about a named release

helm diff
helm upgrade [release_name] [repo/name] --version 13
helm rollback [release_name] 3 #revision number
helm monitor #Used to monitor a release and perform a rollback if certain events occur

helm secrets #Used to help conceal secrets from Helm charts



Test before run

helm unittest #Used to perform unit testing on a Helm chart

helm lint ./nginx-chart # to check the configuration about mistakes

helm template ./nginx-chart # to see what would be genarated with values from values.yaml
helm template ./nginx-chart --debug # to see details about the issue

helm install test_release ./nginx-chart --dry-run # to get results from kubernetes if there is an issue

helm package ./nginx-chart # to package the chart