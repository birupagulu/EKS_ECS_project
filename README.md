# EKS_ECS_project
aws eks --region <region> update-kubeconfig --name <cluster-name>
kubectl get nodes
kubectl apply -f deployment.yaml
kubectl config current-context
kubectl config use-context <context-name>
kubectl get pods -n <namespace>
kubectl get deployments -n <namespace>
kubectl create namespace my-namespace
kubectl config set-context --current --namespace=my-namespace
kubectl config view --minify --output 'jsonpath={..namespace}'
