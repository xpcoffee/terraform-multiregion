output "service_name" {
  description = "Name of service-2"
  value       = module.service_2.service_name
}

output "service_port" {
  description = "Port of service-2"
  value       = module.service_2.service_port
}
