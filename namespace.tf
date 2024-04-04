provider "kubectl" {
  config_path    = "~/.kube/config"  # Path to your kubeconfig file
}

resource "kubectl_manifest" "example_namespace" {
  yaml_body = <<-EOT
    apiVersion: v1
    kind: Namespace
    metadata:
      name: your-namespace-name
  EOT
}


provider "kubernetes" {
  config_path = "~/.kube/config"  # Path to your kubeconfig file
}

resource "kubernetes_namespace" "example_namespace" {
  metadata {
    name = "your-namespace-name"
  }
}

resource "kubernetes_deployment" "example_deployment" {
  metadata {
    name      = "example-deployment"
    namespace = kubernetes_namespace.example_namespace.metadata[0].name
    labels = {
      app = "example"
    }
  }

  spec {
    replicas = 3

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
          image = "your-ecr-image-uri:tag"  # Replace with your ECR image URI and tag
          name  = "example-container"
        }
      }
    }
  }
}
