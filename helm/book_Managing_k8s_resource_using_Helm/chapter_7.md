pages 219-247

# Dependecies

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
