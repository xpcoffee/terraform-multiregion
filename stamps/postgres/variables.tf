variable "cluster_state_path" {
  description = "Path to cluster terraform state file"
  type        = string
}

variable "postgres_replicas" {
  description = "Number of replicas for PostgreSQL"
  type        = number
  default     = 1
}

variable "postgres_image" {
  description = "Docker image for PostgreSQL"
  type        = string
  default     = "postgres:14"
}
