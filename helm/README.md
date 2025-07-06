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


##Examples:##
#Task 1: Install a Chart
#Install the nginx Helm chart from the stable repository. Use a #specific release name (my-nginx) and set the replicas to 3.

helm repo add [name] [url]  # to add repo
helm search repo nginx --versions  # to search on added repo
helm install my-nginx repo/nginx --set replicas=3

#Task 2: List Releases
#List all Helm releases that are currently deployed in the namespace #kube-system.

helm list --namespace kube-system

#Task 3: Upgrade a Chart
#You currently have a release named my-app running version 1.0.0 of a #chart. Upgrade it to the next version (e.g., 1.1.0) using Helm.

helm upgrade my-app repo/my-app --version 1.1.0

#Task 4: Customize Values
#Download the redis chart values file (values.yaml) from the #repository. Edit the file to set a custom memory limit of 512Mi for #the master pod, then deploy the chart.

helm pull repo/redis --untar --untardir ./redis-chart  # Download the chart
cd redis-chart
# Edit values.yaml to set memory limit
# For example, set:
resources:
  limits:
    memory: 512Mi
helm install my-redis ./redis-chart -f values.yaml # Deploy with custom values
or
helm install my-redis ./redis-chart --set resources.limits.memory=512Mi  # Deploy with custom values via command line


#Task 5: Rollback a Release
#Rollback the Helm release my-nginx to its previous stable version (prior deployment).

helm history my-nginx # Check the history to find the revision number
helm rollback my-nginx 1  # Assuming the previous version is revision 1
helm status my-nginx # Check the status after rollback to ensure it was successful

#Task 6: Uninstall a Release
#Uninstall the Helm release my-nginx. Make sure all associated Kubernetes resources are deleted.

helm uninstall my-nginx # Uninstall the release and delete associated resources


Task 7: Debugging Failed Installations
You attempted to install a release, but it failed. What Helm command would you issue to debug the failed installation and get detailed information?

helm status my-nginx # Check the status of the release to see why it failed
helm get manifest my-nginx # Get the manifest to see what was applied
helm get all my-nginx # Get all information about the release, including the manifest and values used

helm install my-nginx [repo]/nginx --debug --dry-run # To simulate the installation and see detailed output without actually deploying it
