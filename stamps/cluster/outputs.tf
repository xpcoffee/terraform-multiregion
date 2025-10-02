output "cluster_name" {
  description = "Name of the created cluster"
  value       = module.kind_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "Cluster endpoint"
  value       = module.kind_cluster.cluster_endpoint
}

output "namespace_name" {
  description = "Name of the application namespace"
  value       = module.kind_cluster.namespace_name
}

output "kubernetes_host" {
  description = "Kubernetes cluster endpoint"
  value       = module.kind_cluster.kubernetes_host
}

output "kubernetes_client_certificate" {
  description = "Kubernetes client certificate"
  value       = module.kind_cluster.kubernetes_client_certificate
  sensitive   = true
}

output "kubernetes_client_key" {
  description = "Kubernetes client key"
  value       = module.kind_cluster.kubernetes_client_key
  sensitive   = true
}

output "kubernetes_cluster_ca_certificate" {
  description = "Kubernetes cluster CA certificate"
  value       = module.kind_cluster.kubernetes_cluster_ca_certificate
  sensitive   = true
}

output "region" {
  description = "Region identifier"
  value       = var.region
}

output "stage" {
  description = "Stage identifier"
  value       = var.stage
}
