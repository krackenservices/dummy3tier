BACKEND_IMG ?= backend:latest
FRONTEND_IMG ?= frontend:latest

CONTAINER_TOOL ?= nerdctl
APP_DIR ?= react-rust-postgres

SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

.PHONY: all build build-backend build-backend-k3s build-frontend build-frontend-k3s
all: build
build: build-backend build-frontend

build-backend: build-backend-k3s
build-backend-k3s:
	$(CONTAINER_TOOL) --namespace k8s.io build -t ${BACKEND_IMG} ${APP_DIR}/backend

build-frontend: build-frontend-k3s
build-frontend-k3s:
	$(CONTAINER_TOOL) --namespace k8s.io build -t ${FRONTEND_IMG} ${APP_DIR}/frontend

# KUSTOMIZE Deploy
.PHONY: deploy-k3s-kustomize deploy-backend-k3s-kustomize deploy-frontend-k3s-kustomize deploy-db-k3s-kustomize
deploy-k3s-kustomize: 
	kustomize build ${APP_DIR}/k8s/kustomize/ | kubectl apply -f -
deploy-frontend-k3s-kustomize:
	kustomize build ${APP_DIR}/k8s/kustomize/frontend/ | kubectl apply -f -
deploy-backend-k3s-kustomize:
	kustomize build ${APP_DIR}/k8s/kustomize/backend/ | kubectl apply -f -
deploy-db-k3s-kustomize:
	kustomize build ${APP_DIR}/k8s/kustomize/database/ | kubectl apply -f -

.PHONY: undeploy-k3s-kustomize undeploy-backend-k3s-kustomize undeploy-frontend-k3s-kustomize undeploy-db-k3s-kustomize
undeploy-k3s-kustomize: 
	kustomize build ${APP_DIR}/k8s/kustomize/ | kubectl delete -f - 
undeploy-frontend-k3s-kustomize:
	kustomize build ${APP_DIR}/k8s/kustomize/frontend/ | kubectl delete -f -
undeploy-backend-k3s-kustomize:
	kustomize build ${APP_DIR}/k8s/kustomize/backend/ | kubectl delete -f -
undeploy-db-k3s-kustomize:
	kustomize build ${APP_DIR}/k8s/kustomize/database/ | kubectl delete -f -

# HELM Deploy
.PHONY: deploy-k3s-helm deploy-backend-k3s-helm deploy-frontend-k3s-helm deploy-db-k3s-helm
deploy-k3s-helm: 
	helm dependency build ${APP_DIR}/k8s/helm/umbrella/
	helm upgrade -i dummy3tier ${APP_DIR}/k8s/helm/umbrella/
deploy-frontend-k3s-helm:
	helm upgrade -i dummy3tier-fe ${APP_DIR}/k8s/helm/frontend/
deploy-backend-k3s-helm:
	helm upgrade -i dummy3tier-be ${APP_DIR}/k8s/helm/backend/
deploy-db-k3s-helm:
	helm upgrade -i dummy3tier-db ${APP_DIR}/k8s/helm/database/

.PHONY: undeploy-k3s-helm undeploy-backend-k3s-helm undeploy-frontend-k3s-helm undeploy-db-k3s-helm
undeploy-k3s-helm: 
	helm uninstall dummy3tier 
undeploy-frontend-k3s-helm:
	helm uninstall dummy3tier-fe
undeploy-backend-k3s-helm:
	helm uninstall dummy3tier-be
undeploy-db-k3s-helm:
	helm uninstall dummy3tier-db
