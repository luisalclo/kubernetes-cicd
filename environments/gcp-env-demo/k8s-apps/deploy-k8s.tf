############# BOOKINFO COMPLETE K8S ARCHITECTURE (HCL)################

# ============================================================================
# 1. NAMESPACE
# ============================================================================
resource "kubernetes_namespace_v1" "bookinfo" {
  metadata {
    name = "bookinfo"
    labels = {
      environment = "demo"
      app         = "bookinfo"
    }
  }
}

# ============================================================================
# 2. PRODUCTPAGE (Frontend)
# ============================================================================
resource "kubernetes_deployment_v1" "productpage" {
  metadata {
    name      = "productpage-v1"
    namespace = kubernetes_namespace_v1.bookinfo.metadata[0].name
    labels = {
      app     = "productpage"
      version = "v1"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "productpage"
      }
    }
    template {
      metadata {
        labels = {
          app     = "productpage"
          version = "v1"
        }
      }
      spec {
        container {
          name  = "productpage"
          image = "docker.io/istio/examples-bookinfo-productpage-v1:1.19.1"
          port {
            container_port = 9080
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "productpage_svc" {
  metadata {
    name      = "productpage"
    namespace = kubernetes_namespace_v1.bookinfo.metadata[0].name
    labels = {
      app = "productpage"
    }
  }
  spec {
    type = "LoadBalancer" # Exposes the frontend to the Internet
    selector = {
      app = "productpage"
    }
    port {
      name        = "http"
      port        = 9080
      target_port = 9080
    }
  }
}

# ============================================================================
# 3. DETAILS (Backend)
# ============================================================================
resource "kubernetes_deployment_v1" "details" {
  metadata {
    name      = "details-v1"
    namespace = kubernetes_namespace_v1.bookinfo.metadata[0].name
    labels = {
      app     = "details"
      version = "v1"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "details"
      }
    }
    template {
      metadata {
        labels = {
          app     = "details"
          version = "v1"
        }
      }
      spec {
        container {
          name  = "details"
          image = "docker.io/istio/examples-bookinfo-details-v1:1.19.1"
          port {
            container_port = 9080
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "details_svc" {
  metadata {
    name      = "details"
    namespace = kubernetes_namespace_v1.bookinfo.metadata[0].name
    labels = {
      app = "details"
    }
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = "details"
    }
    port {
      name        = "http"
      port        = 9080
      target_port = 9080
    }
  }
}

# ============================================================================
# 4. REVIEWS (Backend - 3 Versions for load balancing)
# ============================================================================
resource "kubernetes_deployment_v1" "reviews_v1" {
  metadata {
    name      = "reviews-v1"
    namespace = kubernetes_namespace_v1.bookinfo.metadata[0].name
    labels = {
      app     = "reviews"
      version = "v1"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "reviews"
      }
    }
    template {
      metadata {
        labels = {
          app     = "reviews"
          version = "v1" # No stars
        }
      }
      spec {
        container {
          name  = "reviews"
          image = "docker.io/istio/examples-bookinfo-reviews-v1:1.19.1"
          port {
            container_port = 9080
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "reviews_v2" {
  metadata {
    name      = "reviews-v2"
    namespace = kubernetes_namespace_v1.bookinfo.metadata[0].name
    labels = {
      app     = "reviews"
      version = "v2"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "reviews"
      }
    }
    template {
      metadata {
        labels = {
          app     = "reviews"
          version = "v2" # Black stars
        }
      }
      spec {
        container {
          name  = "reviews"
          image = "docker.io/istio/examples-bookinfo-reviews-v2:1.19.1"
          port {
            container_port = 9080
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "reviews_v3" {
  metadata {
    name      = "reviews-v3"
    namespace = kubernetes_namespace_v1.bookinfo.metadata[0].name
    labels = {
      app     = "reviews"
      version = "v3"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "reviews"
      }
    }
    template {
      metadata {
        labels = {
          app     = "reviews"
          version = "v3" # Red stars
        }
      }
      spec {
        container {
          name  = "reviews"
          image = "docker.io/istio/examples-bookinfo-reviews-v3:1.19.1"
          port {
            container_port = 9080
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "reviews_svc" {
  metadata {
    name      = "reviews"
    namespace = kubernetes_namespace_v1.bookinfo.metadata[0].name
    labels = {
      app = "reviews"
    }
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = "reviews" # Load balances across v1, v2, and v3
    }
    port {
      name        = "http"
      port        = 9080
      target_port = 9080
    }
  }
}

# ============================================================================
# 5. RATINGS (Backend - Used by Reviews v2 & v3)
# ============================================================================
resource "kubernetes_deployment_v1" "ratings" {
  metadata {
    name      = "ratings-v1"
    namespace = kubernetes_namespace_v1.bookinfo.metadata[0].name
    labels = {
      app     = "ratings"
      version = "v1"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "ratings"
      }
    }
    template {
      metadata {
        labels = {
          app     = "ratings"
          version = "v1"
        }
      }
      spec {
        container {
          name  = "ratings"
          image = "docker.io/istio/examples-bookinfo-ratings-v1:1.19.1"
          port {
            container_port = 9080
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "ratings_svc" {
  metadata {
    name      = "ratings"
    namespace = kubernetes_namespace_v1.bookinfo.metadata[0].name
    labels = {
      app = "ratings"
    }
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = "ratings"
    }
    port {
      name        = "http"
      port        = 9080
      target_port = 9080
    }
  }
}