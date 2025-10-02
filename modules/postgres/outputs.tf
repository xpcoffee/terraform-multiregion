output "service_name" {
  description = "Name of the PostgreSQL service"
  value       = kubernetes_service.postgres_service.metadata[0].name
}

output "service_port" {
  description = "Port of the PostgreSQL service"
  value       = kubernetes_service.postgres_service.spec[0].port[0].port
}

output "database_host" {
  description = "Database connection host"
  value       = "${kubernetes_service.postgres_service.metadata[0].name}.${var.namespace}.svc.cluster.local"
}