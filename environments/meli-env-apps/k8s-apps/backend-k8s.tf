terraform {
  backend "gcs" {
    bucket = "meli-tf"
    prefix = "terraform/env/meli-env-apps/k8s"
  }
}