variable "namespace" {
  description = "Namespace for the application."
  type        = string
}

variable "common_labels" {
  description = "Common Kubernetes labels."
  type        = map(string)
}

variable "frontend_image_repository" {
  description = "Frontend image repository."
  type        = string
}

variable "frontend_image_tag" {
  description = "Frontend image tag."
  type        = string
}

variable "frontend_image_pull_policy" {
  description = "Frontend image pull policy."
  type        = string
}

variable "backend_image_repository" {
  description = "Backend image repository."
  type        = string
}

variable "backend_image_tag" {
  description = "Backend image tag."
  type        = string
}

variable "backend_image_pull_policy" {
  description = "Backend image pull policy."
  type        = string
}

variable "database_password" {
  description = "PostgreSQL password."
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "PostgreSQL database name."
  type        = string
  default     = "tasksdb"
}

variable "database_user" {
  description = "PostgreSQL database user."
  type        = string
  default     = "app"
}

variable "backend_min_replicas" {
  description = "Minimum backend replicas for HPA."
  type        = number
  default     = 1
}

variable "backend_max_replicas" {
  description = "Maximum backend replicas for HPA."
  type        = number
  default     = 4
}

variable "backend_target_cpu" {
  description = "Target backend CPU utilization percentage."
  type        = number
  default     = 30
}
