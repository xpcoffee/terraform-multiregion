terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
      configuration_aliases = [kubernetes]
    }
  }
}

resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = "postgres-secret"
    namespace = var.namespace
  }

  data = {
    POSTGRES_DB       = "appdb"
    POSTGRES_USER     = "appuser"
    POSTGRES_PASSWORD = "password123"
  }

  type = "Opaque"
}

resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name      = "postgres-pvc"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "standard"
    resources {
      requests = {
        storage = var.stage == "prod" ? "10Gi" : "5Gi"
      }
    }
  }

  wait_until_bound = false
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = var.namespace
    labels = {
      app    = "postgres"
      region = var.region
      stage  = var.stage
    }
  }

  spec {
    replicas = var.postgres_replicas

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app    = "postgres"
          region = var.region
          stage  = var.stage
        }
      }

      spec {
        container {
          image = var.postgres_image
          name  = "postgres"

          env_from {
            secret_ref {
              name = kubernetes_secret.postgres_secret.metadata[0].name
            }
          }

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }

          resources {
            limits = {
              cpu    = var.stage == "prod" ? "1000m" : "500m"
              memory = var.stage == "prod" ? "2Gi" : "1Gi"
            }
            requests = {
              cpu    = var.stage == "prod" ? "500m" : "250m"
              memory = var.stage == "prod" ? "1Gi" : "512Mi"
            }
          }
        }

        volume {
          name = "postgres-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres_service" {
  metadata {
    name      = "postgres-service"
    namespace = var.namespace
    labels = {
      app    = "postgres"
      region = var.region
      stage  = var.stage
    }
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}