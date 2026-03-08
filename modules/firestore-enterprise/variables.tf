# Meli-TF/terraform/modules/firestore-enterprise/variables.tf

# --- General ---

variable "project_id" {
  description = "The main GCP project ID where the database is hosted."
  type        = string
}

variable "database_name" {
  description = "The ID of the database to create."
  type        = string
}

variable "location_id" {
  description = "The location for Firestore (e.g., 'us-central' or 'nam5')."
  type        = string
}

variable "app_user_name" {
  description = "The application username for MongoDB compatibility."
  type        = string
  default     = "app-user"
}

# --- 1. Database Settings (google_firestore_database) ---

variable "db_type" {
  description = "Database type. e.g., 'FIRESTORE_NATIVE' or 'DATASTORE_MODE'."
  type        = string
  default     = "FIRESTORE_NATIVE"
}

variable "db_edition" {
  description = "Database edition. e.g., 'ENTERPRISE' or 'STANDARD'."
  type        = string
  default     = "ENTERPRISE"
}

variable "db_concurrency_mode" {
  description = "Concurrency mode. e.g., 'OPTIMISTIC' or 'PESSIMISTIC'."
  type        = string
  default     = "PESSIMISTIC"
}

variable "db_app_engine_integration" {
  description = "App Engine integration mode. e.g., 'DISABLED'."
  type        = string
  default     = "DISABLED"
}

variable "db_pitr_enablement" {
  description = "Point-in-time recovery enablement state."
  type        = string
  default     = "POINT_IN_TIME_RECOVERY_ENABLED"
}

variable "db_delete_protection" {
  description = "Delete protection state - Examples DELETE_PROTECTION_DISABLED or DELETE_PROTECTION_ENABLED"
  type        = string
  default     = "DELETE_PROTECTION_ENABLED"
}

variable "db_deletion_policy" {
  description = "Deletion policy. 'DELETE' (default) or 'ABANDON'."
  type        = string
  default     = "DELETE"
}

variable "db_tags" {
  description = "A map of tags to assign to the database. IMPORTANT: Must use the Resource Manager Tag format (e.g., {'tagKeys/123' = 'tagValues/456'})."
  type        = map(string)
  default     = {}
}

