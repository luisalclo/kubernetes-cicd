# Meli-TF/terraform/modules/firestore-enterprise/main.tf
# 1. Define the Firestore Database (Enterprise Edition)

# 1. Firestore Database
resource "google_firestore_database" "database" {
  project                             = var.project_id
  name                                = var.database_name
  location_id                         = var.location_id
  type                                = var.db_type
  database_edition                    = var.db_edition
  concurrency_mode                    = var.db_concurrency_mode
  app_engine_integration_mode         = var.db_app_engine_integration
  point_in_time_recovery_enablement   = var.db_pitr_enablement
  delete_protection_state             = var.db_delete_protection
  deletion_policy                     = var.db_deletion_policy
  tags                                = var.db_tags
}

# ============================================================================
# USER CREDENTIALS & SECRET MANAGER
# ============================================================================

# 1. Create Firestore User Credentials
resource "google_firestore_user_creds" "app_user" {
  project  = var.project_id
  # Reference the database resource created in this module
  database = google_firestore_database.database.name 
  name     = var.app_user_name
}

# 2. Create Secret in Secret Manager
resource "google_secret_manager_secret" "mongo_pass" {
  # Using DB name in secret ID to ensure uniqueness if multiple DBs exist
  secret_id = "${var.database_name}-${var.app_user_name}-pass"
  project   = var.project_id

  replication {
    auto {}
  }
}

# 3. Store the generated password as a Secret Version
resource "google_secret_manager_secret_version" "mongo_pass_val" {
  secret      = google_secret_manager_secret.mongo_pass.id
  secret_data = google_firestore_user_creds.app_user.secure_password
}

# ============================================================================
# 4. IAM PERMISSIONS (Automatic Access Grant)
# ============================================================================

# Retrieve current project details to dynamically get the "Project Number"
# (Required because the IAM member string needs the numeric ID, not the text ID)
data "google_project" "current" {
  project_id = var.project_id
}

# Assign the 'datastore.owner' role to the Firestore User Credential created above
resource "google_project_iam_member" "mongo_user_owner" {
  project = var.project_id
  role    = "roles/datastore.owner"

  # Dynamic construction of the principal identifier.
  # Format: principal://firestore.googleapis.com/projects/{PROJECT_NUMBER}/name/databases/{DB_NAME}/userCreds/{USER_NAME}
  member = "principal://firestore.googleapis.com/projects/${data.google_project.current.number}/name/databases/${var.database_name}/userCreds/${var.app_user_name}"
  
  # Explicit dependency to ensure the user credentials exist before assigning permissions
  depends_on = [google_firestore_user_creds.app_user]
}