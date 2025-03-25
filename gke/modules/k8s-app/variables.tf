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