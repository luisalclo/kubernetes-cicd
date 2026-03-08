# Meli-TF/terraform/modules/firestore-enterprise/outputs.tf

output "database_name" {
  description = "The full resource name of the Firestore Enterprise database."
  value       = google_firestore_database.database.name
}

output "location_id" {
  description = "The location ID chosen for Firestore."
  value       = google_firestore_database.database.location_id
}

output "mongo_secret_id" {
  description = "The Resource ID of the Secret Manager secret containing the password."
  value       = google_secret_manager_secret.mongo_pass.secret_id
}

output "mongo_user_name" {
  description = "The created username."
  value       = google_firestore_user_creds.app_user.name
}

output "db_uid" {
  description = "The system UID for the Firestore database (Native)"
  value       = google_firestore_database.database.uid
}