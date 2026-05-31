output "platform_network" {
  description = "Modeled platform network."
  value       = module.platform.network
}

output "platform_nodes" {
  description = "Modeled VM-like platform nodes."
  value       = module.platform.nodes
}

output "namespace" {
  description = "Kubernetes namespace managed by Terraform."
  value       = module.kubernetes_app.namespace
}

output "frontend_service" {
  description = "Frontend Kubernetes service."
  value       = module.kubernetes_app.frontend_service
}

output "backend_service" {
  description = "Backend Kubernetes service."
  value       = module.kubernetes_app.backend_service
}
