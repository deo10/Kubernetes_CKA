└── k8s
    ├── db
    │   └── kustomization.yaml
    ├── kustomization.yaml
    ├── message-broker
    │   └── kustomization.yaml
    └── nginx
        └── kustomization.yaml
4 directories, 12 files


kustomization.yaml file for k8s/db:

resources:
  - db-depl.yaml
  - db-service.yaml
  - db-config.yaml


kustomization.yaml file for k8s/message-broker:

resources:
  - rabbitmq-config.yaml
  - rabbitmq-depl.yaml
  - rabbitmq-service.yaml


kustomization.yaml file for k8s/nginx:

resources:
  - nginx-depl.yaml
  - nginx-service.yaml



Root kustomization.yaml file for k8s directory:

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

# kubernetes resources to be managed by kustomize
resources:
  - db/
  - message-broker/
  - nginx/
#Customizations that need to be made


Finally after defining each kustomization.yaml file let's apply our configuration:
controlplane ~/code ➜  kubectl apply -k /root/code/k8s/
--------------OR---------------
controlplane ~/code ➜  kustomize build /root/code/k8s/ | kubectl apply -f -