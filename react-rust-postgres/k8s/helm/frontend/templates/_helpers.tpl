{{- define "middleware.uri" }}
  {{- printf "%s.%s.svc.cluster.local:%s" .Values.middleware.service.name .Release.Namespace .Values.middleware.service.port }}
{{- end }}