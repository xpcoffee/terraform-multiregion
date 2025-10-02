output "service_name" {
  description = "Name of service-1"
  value       = kubernetes_service.service_1.metadata[0].name
}

output "service_port" {
  description = "Port of service-1"
  value       = kubernetes_service.service_1.spec[0].port[0].port
}
