{{- define "middleware.uri" }}
  {{- printf "%s.%s.svc.cluster.local" .Values.middleware.service.name .Release.Namespace }}
{{- end }}