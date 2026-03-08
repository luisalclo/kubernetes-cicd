# repo../kubernetes-cicd/terraform/environments/infra/backend.tf - Tests

terraform {
  backend "gcs" {
    # The GCS bucket you created to store Terraform state files.
    bucket = "gcp-demo-gkefeb2026"

    # A unique "folder" path within the bucket for this specific environment.
    prefix = "terraform/env/gcp-env-demo/infra"
  }
}