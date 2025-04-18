build:
	docker build -t frontend-api:latest -f frontend-api.Dockerfile .
	docker build -t backend-api:latest -f backend-api.Dockerfile .
	minikube image load frontend-api:latest
	minikube image load backend-api:latest
.PHONY: build

run:
	minikube service frontend-api
.PHONY: run

deploy:
	kubectl apply -f k8s/frontend-api.yaml
	kubectl apply -f k8s/backend-api.yaml
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
