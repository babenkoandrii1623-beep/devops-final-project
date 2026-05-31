variable "name_prefix" {
  description = "Prefix used for platform resources."
  type        = string
  default     = "lab08"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig used by the Kubernetes provider."
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubernetes context name. Use docker-desktop for the local lab."
  type        = string
  default     = "docker-desktop"
}

variable "namespace" {
  description = "Kubernetes namespace for the application."
  type        = string
  default     = "lab08"
}

variable "network_cidr" {
  description = "CIDR block for the platform network model."
  type        = string
  default     = "10.80.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the application subnet model."
  type        = string
  default     = "10.80.1.0/24"
}

variable "vm_count" {
  description = "Number of VM-like nodes in the platform model."
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size used in the platform model."
  type        = string
  default     = "dev-small"
}

variable "frontend_image_repository" {
  description = "Frontend image repository."
  type        = string
  default     = "lab02-microservices-frontend"
}

variable "frontend_image_tag" {
  description = "Frontend image tag."
  type        = string
  default     = "latest"
}

variable "frontend_image_pull_policy" {
  description = "Frontend image pull policy."
  type        = string
  default     = "IfNotPresent"
}

variable "backend_image_repository" {
  description = "Backend image repository."
  type        = string
  default     = "lab02-microservices-backend"
}

variable "backend_image_tag" {
  description = "Backend image tag."
  type        = string
  default     = "latest"
}

variable "backend_image_pull_policy" {
  description = "Backend image pull policy."
  type        = string
  default     = "IfNotPresent"
}

variable "database_password" {
  description = "PostgreSQL password."
  type        = string
  sensitive   = true
  default     = "app_password"
}
