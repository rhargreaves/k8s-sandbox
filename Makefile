TIMESTAMP := $(shell date +%s)
export VERSION := $(TIMESTAMP)

build:
	docker build -t frontend-api:${VERSION} -t frontend-api:latest -f frontend-api.Dockerfile .
	docker build -t backend-api:${VERSION} -t backend-api:latest -f backend-api.Dockerfile .
	minikube image load frontend-api:${VERSION}
	minikube image load backend-api:${VERSION}
.PHONY: build

run:
	minikube service frontend-api
.PHONY: run

deploy:
	envsubst < k8s/frontend-api.yaml | kubectl apply -f -
	envsubst < k8s/backend-api.yaml | kubectl apply -f -
	kubectl apply -f k8s/external-services.yaml
.PHONY: deploy

delete:
	kubectl delete -f k8s/frontend-api.yaml
	kubectl delete -f k8s/backend-api.yaml
.PHONY: delete

clean:
	docker rmi frontend-api:latest
	docker rmi backend-api:latest
	minikube image rm frontend-api:latest
	minikube image rm backend-api:latest
.PHONY: clean

linkerd-install:
	linkerd install --crds | kubectl apply -f -
	linkerd install --set proxyInit.runAsRoot=true | kubectl apply -f -
	linkerd viz install | kubectl apply -f -
.PHONY: linkerd-install
