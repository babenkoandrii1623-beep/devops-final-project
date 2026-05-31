locals {
  backend_labels = merge(var.common_labels, {
    "app.kubernetes.io/component" = "backend"
  })

  frontend_labels = merge(var.common_labels, {
    "app.kubernetes.io/component" = "frontend"
  })

  database_labels = merge(var.common_labels, {
    "app.kubernetes.io/component" = "database"
  })

  backend_selector = {
    "app.kubernetes.io/component" = "backend"
  }

  frontend_selector = {
    "app.kubernetes.io/component" = "frontend"
  }

  database_selector = {
    "app.kubernetes.io/component" = "database"
  }

  database_url = "postgres://${var.database_user}:${var.database_password}@database:5432/${var.database_name}"
}

resource "kubernetes_namespace_v1" "this" {
  metadata {
    name   = var.namespace
    labels = var.common_labels
  }
}

resource "kubernetes_secret_v1" "app" {
  metadata {
    name      = "lab08-app-secret"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = var.common_labels
  }

  data = {
    POSTGRES_PASSWORD = var.database_password
    DATABASE_URL      = local.database_url
  }

  type = "Opaque"
}

resource "kubernetes_config_map_v1" "backend" {
  metadata {
    name      = "backend-config"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = local.backend_labels
  }

  data = {
    NODE_ENV = "production"
    PORT     = "3000"
  }
}

resource "kubernetes_config_map_v1" "database_init" {
  metadata {
    name      = "database-init"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = local.database_labels
  }

  data = {
    "01-init.sql" = <<-SQL
      CREATE TABLE IF NOT EXISTS tasks (
        id SERIAL PRIMARY KEY,
        title TEXT NOT NULL,
        completed BOOLEAN NOT NULL DEFAULT FALSE,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
      );

      INSERT INTO tasks (title, completed)
      VALUES
        ('Split monolith into services', TRUE),
        ('Run the stack with Docker Compose', FALSE)
      ON CONFLICT DO NOTHING;
    SQL
  }
}

resource "kubernetes_persistent_volume_claim_v1" "database" {
  wait_until_bound = false

  metadata {
    name      = "database-data"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = local.database_labels
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_deployment_v1" "database" {
  metadata {
    name      = "database"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = local.database_labels
  }

  spec {
    replicas = 1

    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = local.database_selector
    }

    template {
      metadata {
        labels = local.database_labels
      }

      spec {
        container {
          name              = "database"
          image             = "postgres:16-alpine"
          image_pull_policy = "IfNotPresent"

          port {
            name           = "postgres"
            container_port = 5432
          }

          env {
            name  = "POSTGRES_DB"
            value = var.database_name
          }

          env {
            name  = "POSTGRES_USER"
            value = var.database_user
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.app.metadata[0].name
                key  = "POSTGRES_PASSWORD"
              }
            }
          }

          volume_mount {
            name       = "database-data"
            mount_path = "/var/lib/postgresql/data"
            sub_path   = "postgres-data"
          }

          volume_mount {
            name       = "database-init"
            mount_path = "/docker-entrypoint-initdb.d"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }

          liveness_probe {
            exec {
              command = ["pg_isready", "-U", var.database_user, "-d", var.database_name]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            exec {
              command = ["pg_isready", "-U", var.database_user, "-d", var.database_name]
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }
        }

        volume {
          name = "database-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.database.metadata[0].name
          }
        }

        volume {
          name = "database-init"
          config_map {
            name = kubernetes_config_map_v1.database_init.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "database" {
  metadata {
    name      = "database"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = local.database_labels
  }

  spec {
    selector = local.database_selector

    port {
      name        = "postgres"
      port        = 5432
      target_port = 5432
    }
  }
}

resource "kubernetes_deployment_v1" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = local.backend_labels
  }

  spec {
    selector {
      match_labels = local.backend_selector
    }

    template {
      metadata {
        labels = local.backend_labels
      }

      spec {
        security_context {
          run_as_non_root = true
          run_as_user     = 1000
          run_as_group    = 1000
          fs_group        = 1000
        }

        container {
          name              = "backend"
          image             = "${var.backend_image_repository}:${var.backend_image_tag}"
          image_pull_policy = var.backend_image_pull_policy

          port {
            name           = "http"
            container_port = 3000
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.backend.metadata[0].name
            }
          }

          env {
            name = "DATABASE_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.app.metadata[0].name
                key  = "DATABASE_URL"
              }
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = "http"
            }
            initial_delay_seconds = 20
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = "http"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }

          resources {
            requests = {
              cpu    = "50m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_deployment_v1.database,
    kubernetes_service_v1.database
  ]
}

resource "kubernetes_service_v1" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = local.backend_labels
  }

  spec {
    selector = local.backend_selector

    port {
      name        = "http"
      port        = 3000
      target_port = 3000
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "backend" {
  metadata {
    name      = "backend-hpa"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = local.backend_labels
  }

  spec {
    min_replicas = var.backend_min_replicas
    max_replicas = var.backend_max_replicas

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.backend.metadata[0].name
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.backend_target_cpu
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = local.frontend_labels
  }

  spec {
    replicas = 1

    selector {
      match_labels = local.frontend_selector
    }

    template {
      metadata {
        labels = local.frontend_labels
      }

      spec {
        container {
          name              = "frontend"
          image             = "${var.frontend_image_repository}:${var.frontend_image_tag}"
          image_pull_policy = var.frontend_image_pull_policy

          port {
            name           = "http"
            container_port = 80
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = "http"
            }
            period_seconds = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = "http"
            }
            period_seconds = 10
          }

          resources {
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "250m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = local.frontend_labels
  }

  spec {
    selector = local.frontend_selector

    port {
      name        = "http"
      port        = 80
      target_port = 80
    }
  }
}
