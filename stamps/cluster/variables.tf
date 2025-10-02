variable "cluster_name" {
  description = "Name of the KIND cluster"
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

variable "host_port" {
  description = "Host port for the cluster"
  type        = number
}
