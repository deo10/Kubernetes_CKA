pages 294-308

# Generating release notes

One special type of Helm template is called the NOTES.txt file, located in a
Helm chart’s templates/ folder. This file is used to dynamically generate
usage instructions (or other details) for applications once they are installed with Helm.

Follow these instructions to access your application.
{{- if eq .Values.serviceType "NodePort" }}
export NODE_PORT=$(kubectl get --namespace {{ .Release.Namespace }} -o jsonpath="{.spec.ports[0].nodePort}" services {{.Release.Name }})
export NODE_IP=$(kubectl get nodes --namespace {{ .Release.Namespace }} -o jsonpath="{.items[0].status.addresses[0].address}")
echo "URL: http://$NODE_IP:$NODE_PORT
{{- else }}
export SERVICE_IP=$(kubectl get svc --namespace {{
.Release.Name }} wordpress --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }
}")
echo "URL: http://$SERVICE_IP"
{{- end }}

# Helm template variables

{{ $appName := .Release.Name }}
{{- with .Values.application.configuration }}
My application is called {{ $appName }}
{{- end }}

{{- with .Values.application.configuration }}
My application is called {{ $.Release.Name }}
{{- end }}
---

# Helm template validation

You can perform validation in three different ways (or a combination of these three):
Using the fail function
Using the required function
Using a values.schema.json file

# The fail function

values.yaml
service:
  type: ClusterIP

service.yaml
{{- $serviceTypes := list "ClusterIP" "NodePort" }}
{{- if has .Values.service.type $serviceTypes }}
  type: {{ .Values.service.type }}
{{- else }}
  {{- fail "value 'service.type' must be either 'ClusterIP' or 'NodePort'" }}
{{- end }}

fail with LoadBalancer
-$ helm template fail-example chapter6/examples/fail-example --set service.type=LoadBalancer
Error: execution error at (failexample/templates/service.yaml:10:6): value
'service.type' must be either 'ClusterIP' or 'NodePort'
---

# The required function

values.yaml
service:
  type:
In the service.yaml template for this chart, we see the following output:
spec:
  type: {{ required "value 'service.type' is required" .Values.service.type }}

-$ helm template required-example chapter6/examples/required-example
Error: execution error at (requiredexample/templates/service.yaml:6:11): value'service.type' is required
---

# The values.schema.json file

The values.schema.json file is based on the JSON Schema vocabulary. An
exhaustive overview of JSON Schema is out of scope for this book, but you
can explore the vocabulary yourself by visiting
 http://jsonschema.org/specification.html

Object Validation
.Values.image Ensures that the image object exists
.Values.image.repository Ensures that the image.repository value
exists and is a string
.Values.image.tag Ensures that the image.tag value exists
and is a string
.Values.service Ensures that the service object exists
.Values.service.type Ensures that the service.type value
exists and is set to either ClusterIP or
NodePort
.Values.service.port Ensures that the service.port value
exists and is greater than or equal to 8080

-$ helm template schema-example
chapter6/examples/schema-example --set service.type=LoadBalancer
Error: values don't meet the specifications of the
schema(s) in the following chart(s):
schema-example:
- service.type: service.type must be one of the
following: "ClusterIP", "NodePort"
---

values.schema.json file, located in the chart at chapter6/examples/schema-example within the Git repository:

{
   "$schema": "http://json-schema.org/draft-07/schema",
   "required": [
       "image",
       "service"
   ],
   "properties": {
       "image": {
           "type": "object",
           "required": [
               "repository",
               "tag"
           ],
           "properties": {
               "repository": {
                   "type": "string"
               },
               "tag": {
                   "type": "string"
               }
           }
       },
       "service": {
           "type": "object",
           "required": ["type", "port"],
           "properties": {
             "type": {
               "type": "string",
               "enum": ["ClusterIP", "NodePort"]
             },
             "port": {
               "type": "integer",
               "minimum": 8080
             }
           }
       }
   }
}