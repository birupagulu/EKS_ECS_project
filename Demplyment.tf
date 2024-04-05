terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
 
resource "kubernetes_namespace" "gideons-dev" {
  metadata {
    name = "gideons-dev"
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}

data "aws_vpc" "existing_vpc" {
  id = "vpc-0d870d7c497bbc736" # Replace with your existing VPC ID
}

data "aws_subnet" "subnet1" {
  id = "subnet-0628c7ce75048a5b5" # Replace with your existing subnet ID
}

data "aws_subnet" "subnet2" {
  id = "subnet-03c6c0adeffcfe90f" # Replace with your existing subnet ID
}

data "aws_security_group" "existing_security_group" {
  id = "sg-00e240ac37a7b1b18" # Replace with your existing security group ID
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "gideons_eks"
  role_arn = "arn:aws:iam::573327415341:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS" # Replace with your existing EKS role ARN

  vpc_config {
    subnet_ids         = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]
    security_group_ids = [data.aws_security_group.existing_security_group.id]
    # Enable DNS support and hostnames for the VPC
    endpoint_private_access   = false
    endpoint_public_access    = true
  }
}

resource "kubernetes_deployment" "Configuration-dev" {
  metadata {
    name      = "nginx-deployment"
    namespace = kubernetes_namespace.gideons-dev.metadata[0].name
    labels = {
      app = "nginx-deployment"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx-deployment"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-deployment"
        }
      }

      spec {
        container {
          image = "nginx:latest"  # Replace with your ECR image URI and tag
          name  = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
