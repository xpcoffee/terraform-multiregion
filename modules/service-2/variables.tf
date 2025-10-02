variable "namespace" {
  description = "Kubernetes namespace for service-2"
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
  description = "Number of replicas for service-2"
  type        = number
  default     = 2
}

variable "service_image" {
  description = "Docker image for service-2"
  type        = string
  default     = "httpd:latest"
}
