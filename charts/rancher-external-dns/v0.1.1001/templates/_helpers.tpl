{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "external-dns.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "external-dns.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if ne $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Generate basic labels */}}
{{- define "external-dns.labels" }}
app: {{ template "external-dns.name" . }}
heritage: {{.Release.Service }}
release: {{.Release.Name }}
{{- if .Values.podLabels }}
{{ toYaml .Values.podLabels }}
{{- end }}
{{- end }}

{{- define "external-dns.aws-credentials" }}
[default]
aws_access_key_id = {{ .Values.aws.accessKey }}
aws_secret_access_key = {{ .Values.aws.secretKey }}
{{ end }}


{{- define "external-dns.aws-config" }}
[profile default]
{{- if .Values.aws.roleArn }}
role_arn = {{ .Values.aws.roleArn }}
{{- end }}
region = {{ .Values.aws.region }}
{{ end }}

{{- define "external-dns.alibabacloud-config" }}
accessKeyId: {{ .Values.alibabacloud.accessKey }}
accessKeySecret: {{ .Values.alibabacloud.secretKey }}
{{ end }}

{{- define "system_default_registry" -}}
{{- if .Values.global.systemDefaultRegistry -}}
{{- printf "%s/" .Values.global.systemDefaultRegistry -}}
{{- else -}}
{{- "" -}}
{{- end -}}
{{- end -}}

{{- define "deployment_api_version" -}}
{{- if .Capabilities.APIVersions.Has "apps/v1" -}}
{{- "apps/v1" -}}
{{- else if .Capabilities.APIVersions.Has "apps/v1beta2" -}}
{{- "apps/v1beta2" -}}
{{- else if .Capabilities.APIVersions.Has "apps/v1beta1" -}}
{{- "apps/v1beta1" -}}
{{- else -}}
{{- "extensions/v1beta1" -}}
{{- end -}}
{{- end -}}