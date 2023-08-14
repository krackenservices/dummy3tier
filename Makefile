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

.PHONY: deploy-k3s deploy-backend-k3s deploy-frontend-k3s deploy-db-k3s
deploy-k3s: 
	kustomize build ${APP_DIR}/k8s/kustomize/ | kubectl apply -f -
deploy-frontend-k3s:
	kustomize build ${APP_DIR}/k8s/kustomize/frontend/ | kubectl apply -f -
deploy-backend-k3s:
	kustomize build ${APP_DIR}/k8s/kustomize/backend/ | kubectl apply -f -
deploy-db-k3s:
	kustomize build ${APP_DIR}/k8s/kustomize/database/ | kubectl apply -f -

.PHONY: undeploy-k3s undeploy-backend-k3s undeploy-frontend-k3s undeploy-db-k3s
undeploy-k3s: 
	kustomize build ${APP_DIR}/k8s/kustomize/ | kubectl delete -f - 
undeploy-frontend-k3s:
	kustomize build ${APP_DIR}/k8s/kustomize/frontend/ | kubectl delete -f -
undeploy-backend-k3s:
	kustomize build ${APP_DIR}/k8s/kustomize/backend/ | kubectl delete -f -
undeploy-db-k3s:
	kustomize build ${APP_DIR}/k8s/kustomize/database/ | kubectl delete -f -
