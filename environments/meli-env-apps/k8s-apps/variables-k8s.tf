# variables-k8s.tf

variable "remote_state" {
  description = "GCS bucket data for reading the status of the Infrastructure layer"
  type = object({
    bucket = string
    prefix = string
  })
}

variable "gcp" {
  description = "Global Google Cloud context configuration."
  type = object({
    project_id = string
    region     = string
  })
}

variable "namespaces" {
  description = "Kubernetes namespace names."
  type = object({
    locust     = string
    java_apps  = string
    monitoring = string
  })
}

variable "images" {
  description = "Full Artifact Registry URLs for the container images."
  type = object({
    java_app        = string
    locust_test     = string
    locust_exporter = string
  })
}

variable "scaling" {
  description = "Replica counts for the Kubernetes deployments."
  type = object({
    java_replicas   = number
    locust_workers  = number
  })
}


variable "storage" {
  description = "Persistent Volume Claim (PVC) sizes for monitoring services."
  type = object({
    prometheus = string
    grafana    = string
  })
}

variable "prometheus_config" {
  description = "Data retention settings for Prometheus"
  type = object({
    retention_time = string
    retention_size = string
  })
  default = {
    retention_time = "120d"  # Standard Default
    retention_size = "9GB"  # Secure default for 10GB disk
  }
}

variable "grafana_root_url" {
  description = "The public URL where Grafana is accessible to render images (e.g., http://1.2.3.4/)"
  type        = string
}


variable "locust_storage" {
  description = "Configuration URI for Locust to download settings."
  type = object({
    config_uri = string # e.g., gs://mi-bucket/config.json
  })
}

variable "locust_config_loglevel" {
  description = "Locust logging level (DEBUG, INFO, WARNING, ERROR)"
  type        = string
  default     = "DEBUG" # Default value - Change to INFO for less verbosity.
}