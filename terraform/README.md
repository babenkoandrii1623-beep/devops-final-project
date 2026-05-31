# Terraform IaC

This folder contains Terraform configuration for Lab 08.

The configuration is split into modules:

- `modules/platform` describes the platform layer: network, subnet and VM-like nodes.
- `modules/kubernetes-app` deploys the microservices application into Kubernetes.

For the local lab environment, the platform module models cloud resources with Terraform-managed data resources. In a real cloud environment, this module can be replaced with AWS, Azure, GCP or another cloud provider.

Main commands:

```powershell
terraform -chdir=terraform fmt -recursive
terraform -chdir=terraform init
terraform -chdir=terraform validate
terraform -chdir=terraform plan -out lab08.tfplan
terraform -chdir=terraform apply -auto-approve lab08.tfplan
terraform -chdir=terraform output
```
