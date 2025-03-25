variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
  default     = "postgres"
}

variable "option_a" {
  description = "First option for the vote"
  type        = string
  default     = "Cats"
}

variable "option_b" {
  description = "Second option for the vote"
  type        = string
  default     = "Dogs"
}

variable "image_registry" {
  description = "Container registry for images"
  type        = string
  default     = "europe-west9-docker.pkg.dev/calcium-post-453513-b5/voting-image"
}
