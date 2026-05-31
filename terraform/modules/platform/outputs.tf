output "network" {
  description = "Modeled network resource."
  value       = terraform_data.network.output
}

output "subnet" {
  description = "Modeled subnet resource."
  value       = terraform_data.subnet.output
}

output "nodes" {
  description = "Modeled VM-like nodes."
  value       = [for node in terraform_data.vm : node.output]
}
