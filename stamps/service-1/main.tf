terraform {
  required_version = ">= 1.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }

  # Backend will be configured via -backend-config
  backend "local" {}
}

# Read cluster state
data "terraform_remote_state" "cluster" {
  backend = "local"

  config = {
    path = var.cluster_state_path
  }
}

# Read postgres state
data "terraform_remote_state" "postgres" {
  backend = "local"

  config = {
    path = var.postgres_state_path
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.cluster.outputs.kubernetes_host
  client_certificate     = data.terraform_remote_state.cluster.outputs.kubernetes_client_certificate
  client_key             = data.terraform_remote_state.cluster.outputs.kubernetes_client_key
  cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.kubernetes_cluster_ca_certificate
}

module "service_1" {
  source = "../../modules/service-1"

  namespace      = data.terraform_remote_state.cluster.outputs.namespace_name
  region         = data.terraform_remote_state.cluster.outputs.region
  stage          = data.terraform_remote_state.cluster.outputs.stage
  database_host  = data.terraform_remote_state.postgres.outputs.database_host
  service_replicas = var.service_replicas
  service_image    = var.service_image

  providers = {
    kubernetes = kubernetes
  }
}
