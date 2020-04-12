provider "kubernetes" {}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx"
  }
  spec {
    selector = {
      env = kubernetes_deployment.nginx.metadata[0].labels.env
    }
    port {
      port = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      env = "dev"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        env = "dev"
      }
    }

    template {
      metadata {
        labels = {
          env = "dev"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "nginx"
          port {
            container_port = 80
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              port = 80
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}
