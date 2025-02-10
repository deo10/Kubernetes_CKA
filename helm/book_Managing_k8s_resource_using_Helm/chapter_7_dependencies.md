pages 219-247

# Dependecies

- Requirements.yaml File:
The requirements.yaml file is where you define the dependencies for your Helm chart.
Each dependency entry includes information such as the chart name, version constraints, repository URL, and alias (optional).

- Charts Directory:
The charts/ directory contains the downloaded dependencies, which are typically packaged as tarballs (.tgz files).
Helm uses these tarballs during the chart installation process to ensure that all required components are available.

- Installing Charts with Dependencies:
When you install a Helm chart that has dependencies, Helm automatically resolves and installs those dependencies first.
Helm uses the information in the requirements.lock file to ensure that the correct versions of dependencies are installed.

- Updating Dependencies:
If you make changes to the requirements.yaml file or want to update the dependencies to newer versions, you can use the helm dependency update command again.
This command downloads the latest versions of the dependencies based on the version constraints specified in requirements.yaml.

Dependencies in Helm charts help manage complex application deployments by ensuring that all required components are included and properly configured. They also simplify the process of maintaining and updating charts over time.


helm show chart bitnami/wordpress --version 12.1.4

dependencies:
- condition: mariadb.enabled
name: mariadb
repository: https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
version: 9.x.x
- condition: memcached.enabled
name: memcached
repository: https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
version: 5.x.x

helm dependency list \ helm dep list
- Lists the dependencies for the given chart.

helm dependency update
- Downloads the dependencies (as .tgz files) listed in Chart.yaml and generates a Chart.lock file.

helm dependency build
- Downloads the dependencies listed in Chart.lock. If the
Chart.lock file is not found, then this command will
mirror the behavior of the helm dependency update
command.

# Conditionals

dependencies:
- name: mariadb
  repository: https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
  version: 9.5.0
  condition: mariadb.enabled
  tags:
    - backend
    - database
