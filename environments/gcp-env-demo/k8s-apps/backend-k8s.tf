terraform {
  backend "gcs" {
    bucket = "gcp-demo-gkefeb2026"
    prefix = "terraform/env/gcp-env-demo/k8s-apps"
  }
}