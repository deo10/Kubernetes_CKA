# Task 1: Create a Custom Chart
# Create a new Helm chart named custom-app. Modify the values.yaml file to:

# Set the application name to my-custom-app.
# Configure 2 replicas for the deployment.
# Deploy the chart in the namespace custom-namespace.

# helm create empty chart
$ helm create custom-app

# Modify the Chart.yaml file to set the name to my-custom-app and description to custom-app.
$ cd custom-app
$ vi Chart.yaml
# Modify the values.yaml file to set the replicas to 2.
$ vi values.yaml
# Modify the deployment.yaml file to use the application name from values.yaml.
$ vi templates/deployment.yaml
# Modify the service.yaml file to use the application name from values.yaml.
$ vi templates/service.yaml
# Create the custom-namespace if it does not exist.
$ kubectl create namespace custom-namespace || true
# Install the chart in the custom-namespace.
$ helm install my-custom-app . --namespace custom-namespace
# Verify the deployment and service are created in the custom-namespace.
$ kubectl get deployments -n custom-namespace
$ kubectl get services -n custom-namespace
# Verify the application is running by checking the pods.
$ kubectl get pods -n custom-namespace
# Verify the service is accessible.
$ kubectl port-forward svc/my-custom-app 8080:80 -n custom-namespace
# Open a web browser and navigate to http://localhost:8080 to see the application running.
# Clean up the resources after testing.
$ helm uninstall my-custom-app --namespace custom-namespace