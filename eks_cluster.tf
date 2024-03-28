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
