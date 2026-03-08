# ============================================================================
# 1. REMOTE STATE CONFIGURATION (Connection to GKE)
# ============================================================================

variable "remote_state" {
  description = "GCS bucket data for reading the status of the Infrastructure layer"
  type = object({
    bucket = string
    prefix = string
  })
}

# ============================================================================
# 2. GCP PROJECT CONTEXT
# ============================================================================

variable "gcp" {
  description = "Global Google Cloud context configuration."
  type = object({
    project_id = string
    region     = string
  })
}