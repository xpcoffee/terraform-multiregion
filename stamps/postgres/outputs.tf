output "service_name" {
  description = "Name of the PostgreSQL service"
  value       = module.postgres.service_name
}

output "database_host" {
  description = "PostgreSQL database host"
  value       = module.postgres.database_host
}

output "service_port" {
  description = "PostgreSQL service port"
  value       = module.postgres.service_port
}
