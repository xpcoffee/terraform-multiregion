output "cluster_name" {
  description = "Name of the created cluster"
  value       = kind_cluster.cluster.name
}

output "cluster_endpoint" {
  description = "Cluster endpoint"
  value       = kind_cluster.cluster.endpoint
}

output "kubeconfig" {
  description = "Kubeconfig for the cluster"
  value       = kind_cluster.cluster.kubeconfig
  sensitive   = true
}

output "namespace_name" {
  description = "Name of the application namespace"
  value       = kubernetes_namespace.app_namespace.metadata[0].name
}

output "kubernetes_host" {
  description = "Kubernetes cluster endpoint"
  value       = kind_cluster.cluster.endpoint
}

output "kubernetes_client_certificate" {
  description = "Kubernetes client certificate"
  value       = kind_cluster.cluster.client_certificate
  sensitive   = true
}

output "kubernetes_client_key" {
  description = "Kubernetes client key"
  value       = kind_cluster.cluster.client_key
  sensitive   = true
}

output "kubernetes_cluster_ca_certificate" {
  description = "Kubernetes cluster CA certificate"
  value       = kind_cluster.cluster.cluster_ca_certificate
  sensitive   = true
}