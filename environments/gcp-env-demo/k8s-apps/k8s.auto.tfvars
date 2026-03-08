# ============================================================================
# 1. Connection from K8S provider to GKE infra layer (State file)
# ============================================================================
remote_state = {
  bucket = "gcp-demo-gkefeb2026" 
  prefix = "terraform/env/gcp-env-demo/infra" # O la ruta exacta que usaste
}

# ============================================================================
# 2. Project Context
# ============================================================================
gcp = {
  project_id = "developer-sandbox-489120"
  region     = "us-central1"
}