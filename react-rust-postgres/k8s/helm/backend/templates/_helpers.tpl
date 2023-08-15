{{- define "database.uri" }}
  {{- printf "%s.%s.svc.cluster.local" .Values.database.service.name .Release.Namespace }}
{{- end }}