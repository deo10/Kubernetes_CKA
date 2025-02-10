pages 423-454
# Advanced Deployment Patterns

- Automating Helm with CD and GitOps
- Using Helm with the Operator Framework
- Helm Security Considerations

# Automating Helm with CD and GitOps

ArgoCD example

Namespace creation:
nm for ArgoCD
->kubectl create namespace argo
where we will deploy an example Helm chart from Argo CD:
->kubectl create namespace chapter10
We will use these namespaces to demonstrate deploying a Helm chart
across multiple environments using Argo CD:
->kubectl create namespace chapter10-dev
->kubectl create namespace chapter10-prod

Install ArgoCD
-> helm repo add argo https://argoproj.github.io/argo-helm

-> helm install argo argo/argo-cd –-version 4.5.0 --values chapter10/argo-values/values.yaml -n argo

First, we need to get the admin password that was randomly
generated during the Helm installation.
We can do this by accessing a Kubernetes secret in the argo namespace:
-> kubectl get secret argocd-initial-admin-secret –n argo –o jsonpath='{.data.password}' | base64 –d

login: admin
Pass: result of the command above

Port Fwd:
kubectl port-forward svc/argo-argocd-server 8443:443 –n argo

Open in browser:
https://localhost:8443


App Deploymnet

Local one

https://github.com/PacktPublishing/Managing-Kubernetes-Resources-using-Helm/blob/main/chapter10/local-chart/application.yaml

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx
  namespace: argo
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    path: helm-charts/charts/nginx/
    repoURL: https://github.com/PacktPublishing/Managing-Kubernetes-Resources-using-Helm.git
    targetRevision: HEAD
    helm:
      values: |-
        resources:
          limits:
            cpu: 50m
            memory: 128Mi
          requests:
            cpu: 50m
            memory: 128Mi
  destination:
    server: https://kubernetes.default.svc
    namespace: chapter10
  syncPolicy:
    automated:
      prune: true
      selfHeal: true

-> $ kubectl apply –f chapter10/localchart/application.yaml -n argo

---
from a remote Helm chart repository

https://github.com/PacktPublishing/Managing-Kubernetes-Resources-using-Helm/blob/main/chapter10/remote-registry/application.yaml


apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nginx
  namespace: argo
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    chart: nginx
    targetRevision: 9.7.6
    repoURL: https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
    helm:
      values: |-
        resources:
          limits:
            cpu: 50m
            memory: 128Mi
          requests:
            cpu: 50m
            memory: 128Mi
  destination:
    server: https://kubernetes.default.svc
    namespace: chapter10
  syncPolicy:
    automated:
      prune: true
      selfHeal: true

---
to multiple environments

Dev would look as follows:
destination:
  server: https://kubernetes.default.svc
  namespace: dev

Prod would be very similar, but we would specify prod in the namespace property:
destination:
  server: https://kubernetes.default.svc
  namespace: prod

https://github.com/PacktPublishing/Managing-Kubernetes-Resources-using-Helm/blob/main/chapter10/multiple-envs/applicationset.yaml

apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: nginx
  namespace: argo
spec:
  generators:
    - list:
        elements:
          - env: dev
          - env: prod
  template:
    metadata:
      name: nginx-{{ env }}
    spec:
      project: default
      source:
        path: chapter10/multiple-envs/nginx
        repoURL: https://github.com/PacktPublishing/Managing-Kubernetes-Resources-using-Helm.git
        targetRevision: HEAD
        helm:
          releaseName: nginx
          valueFiles:
            - values/common-values.yaml
            - values/{{ env }}/values.yaml
      destination:
        server: https://kubernetes.default.svc
        namespace: chapter10-{{ env }}
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
  syncPolicy:
    preserveResourcesOnDeletion: false

values for each env are under:
https://github.com/PacktPublishing/Managing-Kubernetes-Resources-using-Helm/tree/main/chapter10/multiple-envs/nginx/values


-> kubectl apply –f chapter10/multipleenvs/applicationset.yaml -n argo
we should see two different applications appear in the argo namespace
-> kubectl get applications –n argo


Questions:

1. **What is the difference between CI and CD?**
   - **CI (Continuous Integration):** The practice of automatically integrating code changes from multiple contributors into a shared repository several times a day. It involves automated testing to ensure that the new code does not break the existing codebase.
   - **CD (Continuous Delivery/Deployment):** The practice of automatically deploying code changes to a staging or production environment after they pass automated tests. Continuous Delivery ensures that the code is always in a deployable state, while Continuous Deployment goes a step further by automatically deploying every change that passes the tests to production.

2. **What is the relationship between CD and GitOps?**
   - **CD (Continuous Delivery/Deployment):** Focuses on automating the deployment process to ensure that code changes can be released quickly and safely.
   - **GitOps:** A specific implementation of CD that uses Git as the single source of truth for declarative infrastructure and applications. GitOps involves using Git repositories to manage and track changes to the infrastructure and application configurations, and automating the deployment process based on these changes.

3. **What is the difference between an Argo CD Application and ApplicationSet?**
   - **Argo CD Application:** Represents a single application deployment in Argo CD. It defines the source of the application (e.g., a Git repository), the target environment (e.g., a Kubernetes cluster), and the desired state of the application.
   - **ApplicationSet:** A higher-level abstraction that allows you to manage multiple Argo CD Applications as a single entity. It uses generators to create multiple applications based on a common template, making it easier to deploy and manage applications across multiple environments.

4. **What is the Argo CD equivalent of passing the --values flag on the command line?**
   - In Argo CD, the equivalent of passing the `--values` flag is specifying the `valueFiles` field in the helm section of the Application or ApplicationSet manifest. This field allows you to provide one or more values files to customize the Helm chart deployment.

5. **What is the Argo CD equivalent of passing the --set flag on the command line?**
   - In Argo CD, the equivalent of passing the `--set` flag is specifying the `parameters` field in the helm section of the Application or ApplicationSet manifest. This field allows you to set individual Helm chart values directly in the manifest.

6. **What is an ApplicationSet generator? Why are generators useful when deploying to multiple environments?**
   - **ApplicationSet Generator:** A component of Argo CD that dynamically generates multiple Argo CD Applications based on a common template and a set of input parameters. Generators can use various sources, such as lists, Git directories, or cluster resources, to create the applications.
   - **Usefulness:** Generators are useful when deploying to multiple environments because they allow you to define a single template for your application and automatically create multiple instances of the application for different environments (e.g., dev, staging, prod). This reduces duplication and ensures consistency across environments.

