pages 253-273

# Template basics

# Built-in objects
.Values
Used to access values in the values.yaml file or values
that were provided using the --values and --set flags
.Release
Used to access metadata about the Helm release, such
as its name, namespace, and revision number
.Chart
Used to access metadata about the Helm chart, such as
its name and version
.Template
Used to access metadata about chart templates, such
as their filename and path
.Capabilities
Used to access information about the Kubernetes
cluster
.Files
Used to access arbitrary files within a Helm chart
directory
.
The root object

# example with .Release object
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}
data:
  config.properties: |-
    namespace={{ .Release.Namespace }}

.Release object options:
.Release.Name
.Release.Namespace
.Release.IsUpgrade
.Release.IsInstall
.Release.Revision
.Release.Service

# example with .Release .Chart .Values
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}
  labels:
    helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
    app.kubernetes.io/version: {{ .Chart.AppVersion }}
data:
  config.properties: |-
    chapterNumber={{ .Values.chapterNumber }}
    chapterName={{ .Values.chapterName }}

# example with .Files
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}
data:
  config.properties: |-
    {{ .Files.Get "files/config.properties" }}