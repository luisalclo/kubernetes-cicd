variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "region" {
  description = "The location of the repository."
  type        = string
}

variable "repository_id" {
  description = "The last part of the repository name, for example: my-repo."
  type        = string
}

variable "description" {
  description = "The user-provided description of the repository."
  type        = string
  default     = "Docker repository"
}
