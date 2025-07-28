Task 5: Configure Resource Limits for an Application
Install the nginx chart with custom resource limits using the --set flag:

CPU limit: 500m
Memory limit: 256Mi
Deploy it with a release name nginx-limited in the namespace resources-test-namespace.

#task5: steps to complete the task
1. Create the namespace resources-test-namespace if it does not exist.
```bash
$ kubectl create namespace resources-test-namespace --dry-run=client -o yaml | kubectl apply -f -
```
2. Install the nginx chart with custom resource limits using the --set flag:
```bash
$ helm install nginx-limited bitnami/nginx --namespace resources-test-namespace --set resources.limits.cpu=500m,resources.limits.memory=256Mi
```
3. Verify the deployment:
```bash
$ kubectl get pods -n resources-test-namespace
```
4. Check the resource limits of the nginx pod:
```bash
$ kubectl get pod -n resources-test-namespace -o jsonpath='{.items[*].spec.containers[*].resources.limits}'
```
5. If you need to update the resource limits, you can use the following command:
```bash
$ helm upgrade nginx-limited bitnami/nginx --namespace resources-test-namespace --set resources.limits.cpu=500m,resources.limits.memory=256Mi
```
