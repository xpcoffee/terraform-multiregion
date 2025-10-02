terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
      configuration_aliases = [kubernetes]
    }
  }
}

resource "kubernetes_config_map" "service_config" {
  metadata {
    name      = "service-config"
    namespace = var.namespace
  }

  data = {
    DATABASE_HOST = var.database_host
    DATABASE_PORT = "5432"
    DATABASE_NAME = "appdb"
    REGION        = var.region
    STAGE         = var.stage
  }
}

resource "kubernetes_deployment" "service_1" {
  metadata {
    name      = "service-1"
    namespace = var.namespace
    labels = {
      app     = "service-1"
      service = "web"
      region  = var.region
      stage   = var.stage
    }
  }

  spec {
    replicas = var.service_1_replicas

    selector {
      match_labels = {
        app = "service-1"
      }
    }

    template {
      metadata {
        labels = {
          app     = "service-1"
          service = "web"
          region  = var.region
          stage   = var.stage
        }
      }

      spec {
        container {
          image = var.service_1_image
          name  = "service-1"

          env_from {
            config_map_ref {
              name = kubernetes_config_map.service_config.metadata[0].name
            }
          }

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = var.stage == "prod" ? "500m" : "250m"
              memory = var.stage == "prod" ? "512Mi" : "256Mi"
            }
            requests = {
              cpu    = var.stage == "prod" ? "250m" : "100m"
              memory = var.stage == "prod" ? "256Mi" : "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "service_1" {
  metadata {
    name      = "service-1"
    namespace = var.namespace
    labels = {
      app     = "service-1"
      service = "web"
      region  = var.region
      stage   = var.stage
    }
  }

  spec {
    selector = {
      app = "service-1"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "service_2" {
  metadata {
    name      = "service-2"
    namespace = var.namespace
    labels = {
      app     = "service-2"
      service = "api"
      region  = var.region
      stage   = var.stage
    }
  }

  spec {
    replicas = var.service_2_replicas

    selector {
      match_labels = {
        app = "service-2"
      }
    }

    template {
      metadata {
        labels = {
          app     = "service-2"
          service = "api"
          region  = var.region
          stage   = var.stage
        }
      }

      spec {
        container {
          image = var.service_2_image
          name  = "service-2"

          env_from {
            config_map_ref {
              name = kubernetes_config_map.service_config.metadata[0].name
            }
          }

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = var.stage == "prod" ? "500m" : "250m"
              memory = var.stage == "prod" ? "512Mi" : "256Mi"
            }
            requests = {
              cpu    = var.stage == "prod" ? "250m" : "100m"
              memory = var.stage == "prod" ? "256Mi" : "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "service_2" {
  metadata {
    name      = "service-2"
    namespace = var.namespace
    labels = {
      app     = "service-2"
      service = "api"
      region  = var.region
      stage   = var.stage
    }
  }

  spec {
    selector = {
      app = "service-2"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}