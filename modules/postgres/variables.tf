variable "namespace" {
  description = "Kubernetes namespace for PostgreSQL"
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

variable "postgres_replicas" {
  description = "Number of PostgreSQL replicas"
  type        = number
  default     = 1
}

variable "postgres_image" {
  description = "PostgreSQL Docker image"
  type        = string
  default     = "postgres:14"
}