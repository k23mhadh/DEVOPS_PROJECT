variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone to host the cluster in"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "voting-app-cluster"
}

variable "option_a" {
  description = "First voting option"
  type        = string
  default     = "Cats"
}

variable "option_b" {
  description = "Second voting option"
  type        = string
  default     = "Dogs"
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "image_registry" {
  description = "Container registry for images"
  type        = string
  default     = "europe-west9-docker.pkg.dev/calcium-post-453513-b5/voting-image"
}