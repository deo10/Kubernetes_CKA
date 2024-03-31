pages 247-253

# Working with dependencies

helm search hub redis

helm add repo bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami

helm search repo redis --versions

# update \guestbook\Chart.yaml to add dependencies
apiVersion: v2
name: guestbook
description: An application used for keeping a running record of guests
type: application
version: 0.1.0
appVersion: v5
dependencies:
- name: redis
  repository: https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
  version: 15.5.x
  condition: redis.enabled

# download dependencies under \guestbook\charts\
helm dependency update guestbook

# install chart
helm install guestbook guestbook -n chapter5
# check redis
kubectl get statefulsets.apps -n chapter5
# clean-up
helm unistall guestbook -n chapter5

# Summary
Dependencies can greatly reduce the effort required to deploy complex
applications in Kubernetes. As we saw with our guestbook chart, to deploy a
Redis backend, we only needed to add five lines of YAML to our Chart.yaml
file. Compare this to the effort required to write an entirely separate Redis
chart from scratch, which would have required both a high level of
Kubernetes and Redis expertise.
Helm dependency management supports several different configurations to
declare, as well as configure dependencies. To declare a dependency, you can
specify the chart’s name, version, and repository under the dependencies
map in the Chart.yaml file. You can allow users to toggle whether to enable
or disable each dependency using the condition and tags properties. When
incorporating multiple instances of the same dependency, you can use alias
to provide each with a unique identifier, and when working with
dependencies with complex values, you can use import-values to simplify
how values are propagated from a dependency to a parent chart. To list and
download dependencies, Helm provides a set of helm dependency
subcommands that are used regularly when managing chart dependencies.
In the next chapter, we will dive deep into the next crucial topic in the world
of Helm chart development – templates.

Questions:
1. What file is used to declare chart dependencies? Chart.yaml
2. What is the difference between the helm dependency update and helm
dependency build commands?
helm dependency update - Downloads dependencies defined in Chart.yaml
helm dependency build - Downloads + packages dependencies for distribution

3. What is the difference between the Chart.yaml and Chart.lock files?
Chart.lock - tracks exact dependency versions downloaded
-Generated from Chart.yaml when dependencies are updated
-Contains the fully resolved dependency graph
-Pins the dependencies to specific versions

4. Imagine that you want to allow users to enable or disable dependencies
within your chart. What dependencies properties can you use?
To allow users to enable or disable chart dependencies in Helm, you can make use of the condition and tags properties on dependencies in the Chart.yaml file.
Here's an example:
dependencies:
  - name: mysql
    version: ~1.2.3 
    condition: mysql.enabled
    tags:
      - databases

  - name: redis
    version: ~3.7.0
    condition: redis.enabled
    tags: 
     - caches

Some key points:
-The condition specifies a variable name that controls whether this dependency is enabled
-The variables can then be set during helm install or in a values file
-The tags allow logical groupings of dependencies
To enable the mysql dependency, set:
--set mysql.enabled=true
This provides a clean way for users to customize the dependencies included in the chart install.

The tags also allow referencing groups with something like:
--set 'databases=true'
So in summary, condition and tags in Chart.yaml dependencies give users control over what gets included.


5. What dependencies properties should you use if you need to declare
multiple invocations of the same dependency?
You can use the aliases property in the Chart.yaml file.
Here is an example with two instances of the PostgreSQL chart:

dependencies:
  - name: postgresql
    version: 9.9.9
    repository: https://charts.example.com
    alias: postgres-primary

  - name: postgresql 
    version: 9.9.9
    repository: https://charts.example.com
    alias: postgres-readreplica

Some key points:
-Use the alias property to differentiate each dependency instance
-You can install the same chart multiple times with different configurations
-The alias becomes the chart name referred to in values.yaml file

During rendering, the aliases can be referenced like regular chart names:
{{ .Values.postgres-primary.host }}
{{ .Values.postgres-readreplica.port }} 
This allows full control and unique configurations for each dependency instance.
So in summary, using aliasing allows multiple installations of the same Helm dependency within a single parent chart, each with a unique name.

6. If you have a dependency with complex values, which dependencies
property can you use to simplify the propagated values?
You can use the imports property to import just a subset of values.

dependencies:
  - name: mysql
    version: 5.7.21
    repository: https://example.com/charts
    imports:
      - child: mariadb.port
        parent: mysql_port

This imports only the mariadb.port value from mysql chart and maps it to mysql_port in the parent values.

Some key points on using imports:
-Allows select values from dependency to propagate up
-Avoids cluttering parent values.yaml with unneeded defaults
-child: key refers to the source name in dependency chart
-parent: key refers to target name in parent chart

In summary, the imports property in Chart.yaml gives control over which dependency values propagate into the parent for cleaner values. Less used values can stay confined within the dependency chart.

7. How do you override the values of a dependency?

Set values directly on the command line via --set:
helm install --set dependency.key1=value1 --set dependency.key2=value2

Create a custom values file for the dependency:
dependency-values.yaml:
  key1: value1 
  key2: value2
helm install -f dependency-values.yaml

Set a global key for that dependency in values.yaml:
dependencies:
  override:
    key1: value1
dependency:
  key2: value2
  
Use the overrides key in requirements.yaml:
dependencies:
 - name: dependency
   version: 1.0.0 
   overrides:
     key1: value1

8. As a chart developer, what is the value of using a chart dependency?

Reuse
Don't rewrite functionality that already exists
Leverage code that is tested and maintained by others
Share common dependencies between charts (e.g. shared databases)

Modularity
Keep charts small and focused on single responsibility
Compose more complex applications from multiple charts
Update and maintain charts independently

Simplicity
Hide complexity of dependent apps from end users
Provide simple, standardized configuration for dependencies
Manage full application deployments instead of individual charts

Distribution
Package dependencies for "one click" installs
Eliminate need for users to supply their own dependencies
Create comprehensive descriptions of full app topology

In summary, chart dependencies allow reusing reliable dependencies, keeping charts modular and focused, simplifying full-stack deployments for users, and distributing complete solutions. This improves maintainability long-term.