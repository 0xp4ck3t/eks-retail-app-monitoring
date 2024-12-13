*You can download the files and test the setup with the following commands:**

```bash
git clone https://github.com/0xp4ck3t/eks-retail-app-monitoring.git
cd eks-retail-app-monitoring
terraform init
terraform apply 
```
Use kubectl to run the application:
```kubectl
kubectl apply -f https://raw.githubusercontent.com/aws-containers/retail-store-sample-app/main/dist/kubernetes/deploy.yaml
```
Get the URL for the frontend load balancer like so:
```kubectl
kubectl get svc ui
```
To remove the application use kubectl again:
```kubectl
kubectl delete -f https://raw.githubusercontent.com/aws-containers/retail-store-sample-app/main/dist/kubernetes/deploy.yaml
```

To learn more about the retail app. Visit https://github.com/aws-containers/retail-store-sample-app?tab=readme-ov-file. 