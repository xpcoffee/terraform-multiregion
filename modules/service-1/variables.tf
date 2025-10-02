variable "namespace" {
  description = "Kubernetes namespace for service-1"
  type        = string
}

variable "region" {
  description = "Region identifier"
  type        = string
}

variable "stage" {
  description = "Stage (dev or prod)"
  type        = string
}

variable "database_host" {
  description = "Database connection host"
  type        = string
}

variable "service_replicas" {
  description = "Number of replicas for service-1"
  type        = number
  default     = 2
}

variable "service_image" {
  description = "Docker image for service-1"
  type        = string
  default     = "nginx:latest"
}
