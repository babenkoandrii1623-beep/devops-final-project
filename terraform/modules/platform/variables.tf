variable "name_prefix" {
  description = "Prefix used for platform resource names."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "network_cidr" {
  description = "Network CIDR block."
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR block."
  type        = string
}

variable "vm_count" {
  description = "Number of VM-like nodes."
  type        = number
}

variable "vm_size" {
  description = "VM size."
  type        = string
}
