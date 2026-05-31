{{/*
Expand the chart name.
*/}}
{{- define "lab-microservices.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "lab-microservices.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "lab-microservices.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "lab-microservices.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "lab-microservices.labels" -}}
helm.sh/chart: {{ include "lab-microservices.chart" . }}
app.kubernetes.io/name: {{ include "lab-microservices.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "lab-microservices.componentName" -}}
{{- if .nameOverride -}}
{{- .nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "lab-microservices.fullname" .root) .component | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "lab-microservices.frontendName" -}}
{{- include "lab-microservices.componentName" (dict "root" . "component" "frontend" "nameOverride" .Values.frontend.nameOverride) -}}
{{- end -}}

{{- define "lab-microservices.backendName" -}}
{{- include "lab-microservices.componentName" (dict "root" . "component" "backend" "nameOverride" .Values.backend.nameOverride) -}}
{{- end -}}

{{- define "lab-microservices.databaseName" -}}
{{- include "lab-microservices.componentName" (dict "root" . "component" "database" "nameOverride" .Values.database.nameOverride) -}}
{{- end -}}

{{- define "lab-microservices.secretName" -}}
{{- printf "%s-secret" (include "lab-microservices.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "lab-microservices.backendConfigName" -}}
{{- printf "%s-backend-config" (include "lab-microservices.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "lab-microservices.databaseInitConfigName" -}}
{{- printf "%s-db-init" (include "lab-microservices.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "lab-microservices.frontendServiceAccountName" -}}
{{- printf "%s-sa" (include "lab-microservices.frontendName" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "lab-microservices.backendServiceAccountName" -}}
{{- printf "%s-sa" (include "lab-microservices.backendName" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "lab-microservices.databaseServiceAccountName" -}}
{{- printf "%s-sa" (include "lab-microservices.databaseName" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
