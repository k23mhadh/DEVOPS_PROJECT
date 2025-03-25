variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
}

variable "zone" {
  description = "The zone to host the cluster in"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "machine_type" {
  description = "The machine type to use for the nodes"
  type        = string
  default     = "e2-medium"
}

variable "node_count" {
  description = "The number of nodes in the cluster"
  type        = number
  default     = 3
}