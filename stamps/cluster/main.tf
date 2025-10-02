terraform {
  required_version = ">= 1.0"
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.0.17"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }

  # Backend will be configured via -backend-config
  backend "local" {}
}

provider "kubernetes" {
  host                   = module.kind_cluster.kubernetes_host
  client_certificate     = module.kind_cluster.kubernetes_client_certificate
  client_key             = module.kind_cluster.kubernetes_client_key
  cluster_ca_certificate = module.kind_cluster.kubernetes_cluster_ca_certificate
}

module "kind_cluster" {
  source = "../../modules/kind-cluster"

  cluster_name = var.cluster_name
  region       = var.region
  stage        = var.stage
  host_port    = var.host_port

  providers = {
    kubernetes = kubernetes
  }
}
