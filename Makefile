# To build, push, run, etc. the application using docker directly.

docker-build:
	CGO_ENABLED=0 GOOS=linux go build -a ./...
	docker build -t kristenfjacobs/polibot:1.0.0 .

docker-push:
	docker push kristenfjacobs/polibot:1.0.0

docker-run:
	docker run -d -p 8081:8081 --name polibot -t kristenfjacobs/polibot:1.0.0

docker-test:
	while true; do curl localhost:8081; sleep 1; done

docker-clean:
	docker rm -f polibot
	rm -rf polibot

# Deploying to Kubernetes.
# Note: For kubectl to work, we need to have the location of the clusters 
# configuration file set in the environment, e.g.:
# export KUBECONFIG=<path to kubernetes admin.conf>

kube-deploy:
	kubectl run polibot --image=kristenfjacobs/polibot:1.0.0 --replicas=2 --port=8081
	kubectl expose deployment polibot --name=polibot --type=NodePort

kube-undeploy:
	kubectl delete deployment polibot
	kubectl delete services polibot

kube-status:
	kubectl get deployments
	kubectl get pods -o wide
	kubectl get replicasets
	kubectl get services
	kubectl describe services polibot

kube-test:
	while true; do curl 129.146.10.158; sleep 1; done

# Running the Wercker pipelines locally using the wercker command line tool.
# Note: Ensure we have a wercker.env file available with the following content:
# X_DOCKERHUB_PASSWORD=...
# X_DOCKERHUB_USERNAME=...
# X_KUBERNETES_MASTER=...
# X_CERTIFICATE_AUTHORITY_DATA=...
# X_CLIENT_CERTIFICATE_DATA=...
# X_CLIENT_KEY_DATA=...

wercker-dev:
	wercker dev --expose-ports

wercker-build:
	wercker --environment=wercker.env build

wercker-deploy:
	wercker --environment=wercker.env deploy
