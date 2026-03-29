output "repository_name" {
  description = "The name of the repository."
  value       = google_artifact_registry_repository.docker_repo.name
}

output "repository_url" {
  description = "The full URL of the Artifact Registry repository."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}
