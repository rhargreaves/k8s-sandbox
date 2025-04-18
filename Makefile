build:
	docker build -t hello-world:latest .
	minikube image load hello-world:latest
.PHONY: build

run:
	docker run -p 8080:8080 hello-world:latest
.PHONY: run

deploy:
	kubectl apply -f k8s/hello-world.yaml
.PHONY: deploy

delete:
	kubectl delete -f k8s/hello-world.yaml
.PHONY: delete

clean:
	docker rmi hello-world:latest
	minikube image rm hello-world:latest
.PHONY: clean