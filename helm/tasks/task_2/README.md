Task 2: Add a Helm Dependency
Using the nginx chart, add a Redis subchart as a dependency. Make sure to:

Configure the Redis subchart to run as a single-node instance.
Package the chart with the dependencies included.

Steps to Complete Task 2:
$ helm create nginx
$ cd nginx
# This will create a new Helm chart named nginx.
# Add Redis as a dependency in the Chart.yaml file:
$ vi Chart.yaml
# Add the following lines to the file:
dependencies:
  - name: redis
    version: "18.5.0"
    repository: "https://charts.bitnami.com/bitnami"

# Configure the Redis subchart to run as a single-node instance by editing values.yaml:
$ vi values.yaml
# Set the Redis configuration for a single-node instance.
redis:
  cluster:
    enabled: false
  master:
    persistence:
      enabled: false
  replica:
    enabled: false
  sentinel:
    enabled: false

# Update the dependencies to download the Redis chart:
$ helm dependency update

# Package the chart with the dependencies included:
$ helm package .

# Verify the packaged chart:
$ helm show chart nginx-0.1.0.tgz

# install the chart to test it:
$ helm install nginx ./nginx-0.1.0.tgz