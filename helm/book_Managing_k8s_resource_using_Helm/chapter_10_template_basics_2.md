pages 273-286

# Template basics

# Template functions
quote function - will surround the property with quotation marks, as shown in the following code snippet
data:
  path: {{ quote .Values.fs.path }}

result
/var/props/../configs/my app/config.cfg

lookup function
lookup <apiVersion> <kind> <namespace> <name>
lookup "v1" "ConfigMap" "chapter6" "props"

{{ (lookup "v1" "ConfigMap" "chapter6" "props").data.author }}

+60 other functions

---
pipelines

same as cat file.txt | grep helm
{{ .Values.fs.path | quote }}

clean that can resolve the path fully and remove any relative paths automatically
{{ .Values.fs.path | clean | quote }}
result - "/var/configs/my app/config.cfg"


Both indent and nindent provide formatting capabilities
by indenting content a certain number of spaces, crucial when working with
YAML. The difference between indent and nindent is that nindent will add a
newline character after each line of input, a required step in our use case as
there are multiple annotation properties defined within the Values file.

config.properties: |-
{{- (.Files.Get "files/chapter-details.cfg") | nindent 4}}


TOP 10 from ChatGPT

tpl: Used to render a template string. Useful for complex template rendering.
{{ tpl "Hello, {{ .Values.name }}" . }}

include: Includes and renders a sub-template within the current template.
{{ include "mychart.subchart.tpl" . }}

toYaml: Converts a Go data structure into YAML format.
apiVersion: v1
kind: ConfigMap
data:
  {{- toYaml .Values.config | nindent 2 }}

fromJson and toJson: Convert JSON strings to and from Go data structures.
{{- $myData := fromJson "{\"key\": \"value\"}" }}
{{- toJson $myData }}

default: Sets a default value if a variable is not defined.
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.serviceName | default "my-service" }}

required: Ensures that a value is set and throws an error if it's not.
apiVersion: v1
kind: Pod
metadata:
  name: {{ required "A name is required for the pod" .Values.podName }}

printf: Formats strings using Go's Printf formatting.
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ printf "%s-deployment" .Values.appName }}

toUpper and toLower: Convert strings to uppercase or lowercase.
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Values.configName | toUpper }}

hasKey: Checks if a key exists in a map.
{{- if hasKey .Values "myKey" }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  key: value
{{- end }}

Pipelines: You can chain functions together using pipelines (|).
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Values.secretName }}
data:
  username: {{ .Values.username | b64enc | quote }}
  password: {{ .Values.password | b64enc | quote }}