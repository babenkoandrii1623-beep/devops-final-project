output "namespace" {
  description = "Application namespace."
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

output "frontend_service" {
  description = "Frontend service name."
  value       = kubernetes_service_v1.frontend.metadata[0].name
}

output "backend_service" {
  description = "Backend service name."
  value       = kubernetes_service_v1.backend.metadata[0].name
}

output "database_service" {
  description = "Database service name."
  value       = kubernetes_service_v1.database.metadata[0].name
}
