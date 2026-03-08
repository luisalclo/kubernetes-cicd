# 1. Connection from K8S provider to GKE infra layer
remote_state = {
  bucket = "meli-tf"
  prefix = "terraform/env/meli-env-apps/infra"
}

# 2. Project Context
gcp = {
  project_id = "meli-firestore"
  region     = "us-central1"
}

# 3. Namespaces
namespaces = {
  locust     = "locust"
  java_apps  = "java-apps"
  monitoring = "monitoring"
}

# 4. Container Images (Artifact Registry)
images = {
  java_app        = "us-central1-docker.pkg.dev/meli-firestore/firestore-poc-repo/firestore-poc:20251217-155356"
  locust_test     = "us-central1-docker.pkg.dev/meli-firestore/meli-firestore/locust-firestore-test:v8"
  locust_exporter = "us-central1-docker.pkg.dev/meli-firestore/locust-exporter/locust-exporter:v2"
}

# 5. Scaling Configuration
scaling = {
  java_replicas  = 100
  locust_workers = 100
}

# 6. Storage Configuration (PVC Sizes)
storage = {
  prometheus = "10Gi"
  grafana    = "10Gi"
}

# 7. Locust Configuration for bucket to store JSON files
locust_storage = {
  config_uri = "gs://locust-config/config-locust.json"
}

# 8. Locust Logging Level
locust_config_loglevel = "DEBUG"

# 9. Prometheus Configuration
prometheus_config = {
  retention_time = "120d"
  retention_size = "9GB"
}

# 10. Grafana Public URL (Required for Image Rendering)
# Must match your LoadBalancer IP exactly.
grafana_root_url = "http://136.114.241.199/" #Once Grafana UI maybe through an LB or NodePort, change it for your GRAFANA UI WEB IP 