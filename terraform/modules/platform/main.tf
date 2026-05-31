resource "terraform_data" "network" {
  input = {
    name        = "${var.name_prefix}-${var.environment}-network"
    cidr        = var.network_cidr
    environment = var.environment
  }
}

resource "terraform_data" "subnet" {
  input = {
    name        = "${var.name_prefix}-${var.environment}-app-subnet"
    cidr        = var.subnet_cidr
    network     = terraform_data.network.output.name
    environment = var.environment
  }
}

resource "terraform_data" "vm" {
  count = var.vm_count

  input = {
    name        = "${var.name_prefix}-${var.environment}-node-${count.index + 1}"
    size        = var.vm_size
    subnet      = terraform_data.subnet.output.name
    environment = var.environment
  }
}
