provider "aws" {
  region = "your-region"
}

provider "kubernetes" {
  config_context_cluster = "your-eks-cluster"
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "example-deployment"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "example"
      }
    }

    template {
      metadata {
        labels = {
          app = "example"
        }
      }

      spec {
        container {
          image = "123456789012.dkr.ecr.your-region.amazonaws.com/your-repository:your-tag"
          name  = "example-container"
          # Add other container configurations as needed
        }
      }
    }
  }
}
