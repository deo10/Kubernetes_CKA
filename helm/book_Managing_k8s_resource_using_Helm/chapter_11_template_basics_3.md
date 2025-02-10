pages 286-294

# Template basics

# Helm template control structures
The following control-structure keywords are available:
if/else — Creating conditional blocks for resource generation
with - Modifying the scope of resources being generated
range - Looping over a set of resources

{{- if .Values.readinessProbe.enabled }}
readinessProbe:
httpGet:
path: /healthz
port: 8080
scheme: HTTP
initialDelaySeconds: 30
periodSeconds: 10
{{- end }}

The readinessProbe section will only be included when the condition
evaluates to true.

The logic behind the if/else action
can also be interpreted as follows:

{{ if PIPELINE }}
#Do something
{{ else if OTHER PIPELINE }}
#Do something else
{{ else }}
#Default case
{{ end }}

{{- if .Values.readinessProbe.enabled }}
readinessProbe:
{{- if eq .Values.readinessProbe.type "http" }}
httpGet:
path: /healthz
port: 8080
scheme: HTTP
initialDelaySeconds: 30
periodSeconds: 10
{{- else }}
tcpSocket:
port: 8080
{{- end }}
{{- end }}

example for range function

following were included as values within a values.yaml
service:
  ports:
  - name: http
    port: 80
    targetPort: 8080
  - name: https
    port: 443
    targetPort: 8443

By using the range action, these values can be then applied to the Service, as
shown in the following example:

apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}
  labels:
    helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
    app.kubernetes.io/version: {{ .Chart.AppVersion}}
spec:
  type: ClusterIP
  ports:
  {{- range .Values.service.ports }}
    - port: {{ .port }}
    targetPort: {{ .targetPort }}
    protocol: TCP
    name: {{ .name }}
  {{- end }}
  selector:
    app: {{ .Release.Name }}

result:
apiVersion: v1
kind: Service
metadata:
  name: RELEASE-NAME
  labels:
    helm.sh/chart: CHART-NAME-CHART-VERSION
    app.kubernetes.io/version: CHART-APP-VERSION
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: 8080
      protocol: TCP
      name: http
    - port: 443
      targetPort: 8443
      protocol: TCP
      name: https
  selector:
    app: RELEASE-NAME