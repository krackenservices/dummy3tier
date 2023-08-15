# Dummy 3Tier App

Initial code taken from https://github.com/docker/awesome-compose.git
Added Kustomize and Helm charts for deployment and makefile to make it easier. 

Modifed frontend to take URL for backend from Env Var. 
Front will work from Compose without changes however for K3s/K8s deployment the Frontend should actually point at an ingress in order to accees Backend not a svc.cluster.local address. 

The usecase for this repo is to test building/retrofitting operators or other k3s extensions against an actual app that would reflect an actual deployment.