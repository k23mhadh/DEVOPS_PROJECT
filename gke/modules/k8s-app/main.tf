# Create the database initialization job to ensure tables exist
resource "kubernetes_job" "db_init" {
  metadata {
    name = "db-init"
  }

  spec {
    template {
      metadata {
        labels = {
          app = "db-init"
        }
      }

      spec {
        container {
          name  = "db-init"
          image = "postgres:15-alpine"
          
          command = [
            "/bin/sh", 
            "-c", 
            "PGPASSWORD=postgres psql -h db -U postgres -d postgres -c 'CREATE TABLE IF NOT EXISTS votes (id VARCHAR(255) NOT NULL UNIQUE, vote VARCHAR(255) NOT NULL, created_at TIMESTAMP DEFAULT NOW())'"
          ]
          
          env {
            name  = "PGPASSWORD"
            value = var.postgres_password
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 5
  }
  
  wait_for_completion = false
  
  depends_on = [
    kubernetes_deployment.db,
    kubernetes_service.db
  ]
}# Redis Deployment
resource "kubernetes_deployment" "redis" {
  metadata {
    name = "redis"
    labels = {
      app = "redis"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
        }
      }

      spec {
        container {
          image = "redis:alpine"
          name  = "redis"
          
          port {
            container_port = 6379
          }
        }
      }
    }
  }
}

# Redis Service
resource "kubernetes_service" "redis" {
  metadata {
    name = "redis"
  }
  spec {
    selector = {
      app = kubernetes_deployment.redis.metadata[0].labels.app
    }
    port {
      port        = 6379
      target_port = 6379
    }
  }
}

# PostgreSQL PVC
resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name = "db-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "standard" # Explicitly set GKE's standard storage class
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

# PostgreSQL Deployment
resource "kubernetes_deployment" "db" {
  metadata {
    name = "db"
    labels = {
      app = "db"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "db"
      }
    }

    template {
      metadata {
        labels = {
          app = "db"
        }
      }

      spec {
        container {
          image = "postgres:15-alpine"
          name  = "postgres"
          
          port {
            container_port = 5432
          }
          
          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }
          
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.postgres_password
          }
          
          env {
            name  = "POSTGRES_DB"
            value = "postgres"
          }
          
          volume_mount {
            name       = "db-storage"
            mount_path = "/var/lib/postgresql"
            sub_path   = "data"
          }
        }
        
        volume {
          name = "db-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

# PostgreSQL Service
resource "kubernetes_service" "db" {
  metadata {
    name = "db"
  }
  spec {
    selector = {
      app = kubernetes_deployment.db.metadata[0].labels.app
    }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}

# Vote Deployment
resource "kubernetes_deployment" "vote" {
  metadata {
    name = "vote"
    labels = {
      app = "vote"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "vote"
      }
    }

    template {
      metadata {
        labels = {
          app = "vote"
        }
      }

      spec {
        container {
          image = "${var.image_registry}/vote"
          name  = "vote"
          
          port {
            container_port = 5000
          }
          
          env {
            name  = "OPTION_A"
            value = var.option_a
          }
          
          env {
            name  = "OPTION_B"
            value = var.option_b
          }
          
          # Add explicit Redis connection
          env {
            name  = "REDIS_HOST"
            value = "redis"
          }
          
          liveness_probe {
            http_get {
              path = "/"
              port = 5000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }
        }
      }
    }
  }
}

# Vote Service
resource "kubernetes_service" "vote" {
  metadata {
    name = "vote"
    labels = {
      app = "vote"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.vote.metadata[0].labels.app
    }
    port {
      port        = 5000
      target_port = 5000
    }
    type = "LoadBalancer"
  }
}

# Worker Deployment
resource "kubernetes_deployment" "worker" {
  metadata {
    name = "worker"
    labels = {
      app = "worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "worker"
      }
    }

    template {
      metadata {
        labels = {
          app = "worker"
        }
      }

      spec {
        container {
          image = "${var.image_registry}/worker"
          name  = "worker"
          
          # Add environment variables for explicit Redis and DB connections
          env {
            name  = "REDIS_HOST"
            value = "redis"
          }
          
          env {
            name  = "DB_HOST"
            value = "db"
          }
          
          env {
            name  = "DB_USER"
            value = "postgres"
          }
          
          env {
            name  = "DB_PASSWORD"
            value = var.postgres_password
          }
          
          env {
            name  = "DB_NAME"
            value = "postgres"
          }
        }
      }
    }
  }
}

# Result Deployment
resource "kubernetes_deployment" "result" {
  metadata {
    name = "result"
    labels = {
      app = "result"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "result"
      }
    }

    template {
      metadata {
        labels = {
          app = "result"
        }
      }

      spec {
        container {
          image = "${var.image_registry}/result"
          name  = "result"
          
          port {
            container_port = 4000
          }
          
          # Add explicit DB connection
          env {
            name  = "DB_HOST"
            value = "db"
          }
          
          env {
            name  = "DB_USER"
            value = "postgres"
          }
          
          env {
            name  = "DB_PASSWORD"
            value = var.postgres_password
          }
          
          env {
            name  = "DB_NAME"
            value = "postgres"
          }
          
          liveness_probe {
            http_get {
              path = "/"
              port = 4000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }
        }
      }
    }
  }
}

# Result Service
resource "kubernetes_service" "result" {
  metadata {
    name = "result"
  }
  spec {
    selector = {
      app = kubernetes_deployment.result.metadata[0].labels.app
    }
    port {
      port        = 4000
      target_port = 4000
    }
    type = "LoadBalancer"
  }
}



# Seed Job (One-time job to seed data)
resource "kubernetes_job" "seed" {
  metadata {
    name = "seed"
  }

  spec {
    template {
      metadata {
        labels = {
          app = "seed"
        }
      }

      spec {
        container {
          image = "${var.image_registry}/seed"
          name  = "seed"
          image_pull_policy = "Always"
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 3
  }
  
  wait_for_completion = false
  
  depends_on = [
    kubernetes_deployment.vote,
    kubernetes_service.vote
  ]
}