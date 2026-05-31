locals {
  common_labels = {
    "app.kubernetes.io/name"       = "lab-microservices"
    "app.kubernetes.io/instance"   = var.namespace
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/part-of"    = "devops-labs"
  }
}

module "platform" {
  source = "./modules/platform"

  name_prefix  = var.name_prefix
  environment  = var.environment
  network_cidr = var.network_cidr
  subnet_cidr  = var.subnet_cidr
  vm_count     = var.vm_count
  vm_size      = var.vm_size
}

module "kubernetes_app" {
  source = "./modules/kubernetes-app"

  namespace                  = var.namespace
  common_labels              = local.common_labels
  frontend_image_repository  = var.frontend_image_repository
  frontend_image_tag         = var.frontend_image_tag
  frontend_image_pull_policy = var.frontend_image_pull_policy
  backend_image_repository   = var.backend_image_repository
  backend_image_tag          = var.backend_image_tag
  backend_image_pull_policy  = var.backend_image_pull_policy
  database_password          = var.database_password

  depends_on = [module.platform]
}
