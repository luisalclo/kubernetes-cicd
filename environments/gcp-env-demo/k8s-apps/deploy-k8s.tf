############# K8S RESOURCES (GKE) MANAGEMENT BELOW ################

# ============================================================================
# KUBERNETES RESOURCES (Namespaces)
# ============================================================================

resource "kubernetes_namespace" "locust_ns" {
  metadata {
    name = var.namespaces.locust
    labels = {
      environment = "benchmarking"
    }
  }
}

resource "kubernetes_namespace" "java_apps_ns" {
  metadata {
    name = var.namespaces.java_apps
    labels = {
      environment = "production"
    }
  }
}

resource "kubernetes_namespace" "monitoring_ns" {
  metadata {
    name = var.namespaces.monitoring
    labels = {
      tool = "prometheus-grafana"
    }
  }
}


