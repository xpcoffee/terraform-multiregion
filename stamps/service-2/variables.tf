variable "cluster_state_path" {
  description = "Path to cluster terraform state file"
  type        = string
}

variable "postgres_state_path" {
  description = "Path to postgres terraform state file"
  type        = string
}

variable "service_replicas" {
  description = "Number of replicas for service-2"
  type        = number
  default     = 2
}

variable "service_image" {
  description = "Docker image for service-2"
  type        = string
  default     = "httpd:latest"
}
