output "service_1_name" {
  description = "Name of service 1"
  value       = kubernetes_service.service_1.metadata[0].name
}

output "service_2_name" {
  description = "Name of service 2"
  value       = kubernetes_service.service_2.metadata[0].name
}

output "service_1_port" {
  description = "Port of service 1"
  value       = kubernetes_service.service_1.spec[0].port[0].port
}

output "service_2_port" {
  description = "Port of service 2"
  value       = kubernetes_service.service_2.spec[0].port[0].port
}