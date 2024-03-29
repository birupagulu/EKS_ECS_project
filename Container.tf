terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
 
# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}

data "aws_vpc" "existing_vpc" {
  id = "vpc-00516f4152e660c22" # Replace with your existing VPC ID
}

data "aws_subnet" "subnet1" {
  id = "subnet-0e6fd3a0ac5d9a751" # Replace with your existing subnet ID
}

data "aws_subnet" "subnet2" {
  id = "subnet-0f9fa849f86e615b4" # Replace with your existing subnet ID
}

data "aws_security_group" "existing_security_group" {
  id = "sg-0ddf46aeb8a98f1a0" # Replace with your existing security group ID
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "gideons_eks"
  role_arn = "arn:aws:iam::077598156737:role/eks_cluster_role" # Replace with your existing EKS role ARN

  vpc_config {
    subnet_ids         = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]
    security_group_ids = [data.aws_security_group.existing_security_group.id]
  }
}

resource "kubernetes_namespace" "gideons" {
  metadata {
    name = "gideons"
  }
}

resource "aws_eks_node_group" "workers" {
  cluster_name = aws_eks_cluster.my_cluster.name
  node_group_name = "gideons-worker-nodes"
  node_role_arn = "arn:aws:iam::077598156737:role/eks_cluster_node_role"
  subnet_ids         = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]

  scaling_config {
    min_size = 1
    max_size = 5
    desired_size = 2
  }
}

data "aws_eks_cluster_auth" "my_cluster" {
  name = aws_eks_cluster.my_cluster.name
}

resource"kubernetes_deployment" "configuration" { 
metadata { 
  name = "configuration-gideonsdev" 
  namespace = kubernetes_namespace.gideons.metadata[0].name
}
spec {
  replicas = 2 
  selector {
    match_labels = {
      app = "configuration-gideonsdev" 
    } 
  } 
  template { 
    metadata { 
      labels = { 
        app = "configuration-gideonsdev"
      } 
    } 
    spec {
      container { 
        image = "077598156737.dkr.ecr.ap-southeast-1.amazonaws.com/dev-gideons-configuration-img:latest" 
        name  = "dev-gideons-configuration-img" 
      } 
    } 
  } 
}
}
