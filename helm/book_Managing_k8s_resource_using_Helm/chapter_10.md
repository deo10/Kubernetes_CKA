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