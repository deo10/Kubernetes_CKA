pages 308-318

# Enabling code reuse with named templates and library charts

Named templates, as with regular Kubernetes templates, are defined under
the templates/ directory. They begin with an underscore and end with the
.tpl file extension. Many charts (including our Guestbook chart) leverage a
file called _helpers.tpl that contains these named templates, though the file does not need to be called helpers. When creating a new chart with the helm create command, this file is included in the scaffolded set of resources.

templates/_helpers.tpl
{{- define "mychart.labels" }}
labels:
  "app.kubernetes.io/instance": {{ .Release.Name }}
  "app.kubernetes.io/managed-by": {{ .Release.Service }}
  "helm.sh/chart": {{ .Chart.Name }}-{{ .Chart.Version }}
  "app.kubernetes.io/version": {{ .Chart.AppVersion}}
{{- end }}

chart.yaml
metadata:
  name: {{ .Release.Name }}
{{- include "mychart.labels" . | indent 2 }}

template-demonstration:
metadata:
  name: template-demonstration
  labels:
    "app.kubernetes.io/instance": template-demonstration
    "app.kubernetes.io/managed-by": Helm
    "helm.sh/chart": mychart-1.0.0
    "app.kubernetes.io/version": 1.0

EXAMPLES:
Bitnami’s common chart, which can be seen at:
https://github.com/bitnami/charts/tree/master/bitnami/common
There, you will find that each of the chart’s templates is actually a tpl file that contains named templates within

# Creating CRDs (custom resources)

An example crds/ folder is shown here:
crds/
    my-custom-resource-crd.yaml
contents:

apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: my-custom-resources.learnhelm.io
spec:
  group: learnhelm.io
  names:
    kind: MyCustomResource
    listKind: MyCustomResourceList
    plural: MyCustomResources
    singular: MyCustomResource
  scope: Namespaced
  version: v1

Then, the templates/ directory can contain an instance of the
MyCustomResource resource (that is, the CR)
templates/
         my-custom-resource.yaml

# Post rendering

Post rendering is applied by adding the --post-renderer flag to the install, upgrade, or template commands. Here is an example:
$ helm install <release-name> <path-to-chart> --post-renderer <path-to-executable>

The <path-to-executable> parameter is an executable file that invokes the
post-renderer. The executable could be anything from a Go program to a shell script invoking another tool, such as Kustomize. Kustomize is a tool used for patching YAML files, so it is often used for post rendering.

example
helm template nginx ../nginx --post-renderer ./hook.sh

https://github.com/PacktPublishing/Managing-Kubernetes-Resources-using-Helm/tree/main/chapter6/examples/post-renderer-example
