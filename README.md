# Kubernetes Sandbox

[![Build](https://github.com/rhargreaves/k8s-sandbox/actions/workflows/build.yaml/badge.svg)](https://github.com/rhargreaves/k8s-sandbox/actions/workflows/build.yaml)

Kubernetes &amp; Ko.

## Requirements

* Docker
* Minikube (`brew install minikube`)
* Linkerd ([manual install](https://linkerd.io/2-edge/overview/index.html))

## Build Services

```
make build
```

## Deploy to Minikube

```
make deploy
```

## Install Linkerd to Cluster

```
make linkerd-install
```
