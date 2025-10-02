variable "namespace" {
  description = "Kubernetes namespace for services"
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

variable "service_1_replicas" {
  description = "Number of replicas for service 1"
  type        = number
  default     = 2
}

variable "service_2_replicas" {
  description = "Number of replicas for service 2"
  type        = number
  default     = 2
}

variable "service_1_image" {
  description = "Docker image for service 1"
  type        = string
  default     = "nginx:latest"
}

variable "service_2_image" {
  description = "Docker image for service 2"
  type        = string
  default     = "httpd:latest"
}