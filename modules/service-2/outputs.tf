output "service_name" {
  description = "Name of service-2"
  value       = kubernetes_service.service_2.metadata[0].name
}

output "service_port" {
  description = "Port of service-2"
  value       = kubernetes_service.service_2.spec[0].port[0].port
}
