terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.0.17"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
      configuration_aliases = [kubernetes]
    }
  }
}

resource "kind_cluster" "cluster" {
  name = var.cluster_name

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"region=${var.region},stage=${var.stage}\""
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = var.host_port
      }
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}

resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = "app-${var.stage}"
    labels = {
      region = var.region
      stage  = var.stage
    }
  }

  depends_on = [kind_cluster.cluster]
}