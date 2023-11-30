#kodekloud lab challenge
#create deployment in k8s using terraform

#install terraform 1.1.5
# install_terraform.sh

#!/bin/bash

#curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
#echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
#sudo apt update
#sudo apt install terraform=1.1.5


#configure provider.tf for kubernetes
#local name = kubernetes
#version = 2.11.0
#kubeconfig file: /root/.kube/config

# provider.tf

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "/root/.kube/config"
}


#Create a terraform resource frontend for kubernetes deployment with following specs:
#Deployment Name: frontend
#Deployment Labels = name: frontend
#Replicas: 4
#Pod Labels = name: webapp
#Image: kodekloud/webapp-color:v1
#Container name: simple-webapp
#Container port: 8080

# main.tf

resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
    labels = {
      name = "frontend"
    }
  }

  spec {
    replicas = 4

    selector {
      match_labels = {
        name = "webapp"
      }
    }

    template {
      metadata {
        labels = {
          name = "webapp"
        }
      }

      spec {
        container {
          name  = "simple-webapp"
          image = "kodekloud/webapp-color:v1"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "webapp-service" {
  metadata {
    name = "webapp-service"
  }
  spec {
    selector = {
       name = kubernetes_deployment.frontend.spec.0.template.0.metadata.0.labels.name
    }
    port {
      port        = 8080
      target_port = 8080
      node_port   = 30080
    }
    type = "NodePort"
  }
}