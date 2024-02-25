pages 180 - 

# creating new Helm chart called guestbook and it's folder structure

helm create guestbook

folder structure created:
.
├── Chart.yaml
├── charts
├── templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml

#install empty created chart
helm install guestbook ./guestbook -n chapter4

#check YAML maifest for all kinds of chart
helm get manifest guestbook -n chapter4

#uninstall chart
helm uninstall guestbook -n chapter4

# Chart.yaml file content

apiVersion: v2 # 2or3 Helm version
name: nginx-chart
description: A helm chart for testing
annotations:
  category: web
type: application
version: 0.1.0 # Chart version
appVersion: "1.0.0" # App version that helm chart will deploy
kubeVersion: "1.24" # K8s version to run app
keywords:
- nginx
- web
home: home-url
icon: icon-url
sources:
- url to the repo

maintainers:
  - name: Andrei Panov
    email: email@email.com


# summary questions

1. What is the file format most used in Kubernetes and Helm? YAML
2. What is the command used to scaffold a new Helm chart? helm create [chart-name]
3. Where is the Helm chart name and version defined? Chart.yaml
4. What are the three required fields in the Chart.yaml file? apiVersion; name; version
5. Helm charts can be made up of many different files. Which files are
required? Chart.yaml; templates/*.yaml;
6. Which folder of a Helm chart is used to contain Kubernetes resource
templates? /templates
7. Which Chart.yaml field is used to describe the application version that a
Helm chart deploys? appVersion
