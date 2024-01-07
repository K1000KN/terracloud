data "azurerm_resource_group" "t-clo-901-mpl-2" {
  name = var.project_name
}

data "azurerm_dev_test_lab" "t-clo-901-mpl-2" {
  name                = var.project_name
  resource_group_name = data.azurerm_resource_group.t-clo-901-mpl-2.name

}

data "azurerm_dev_test_virtual_network" "t-clo-901-mpl-2" {
  name                = var.project_name
  lab_name            = data.azurerm_dev_test_lab.t-clo-901-mpl-2.name
  resource_group_name = data.azurerm_resource_group.t-clo-901-mpl-2.name
}

data "azurerm_subnet" "t-clo-901-mpl-2" {
  name                 = "t-clo-901-mpl-2Subnet"
  resource_group_name  = data.azurerm_resource_group.t-clo-901-mpl-2.name
  virtual_network_name = data.azurerm_dev_test_virtual_network.t-clo-901-mpl-2.name

}

locals {
  list = { for vm_name in var.vm_name : vm_name.name => vm_name }
}

resource "azurerm_dev_test_linux_virtual_machine" "webapp" {
  for_each               = local.list
  name                   = each.key
  lab_name               = data.azurerm_dev_test_lab.t-clo-901-mpl-2.name
  resource_group_name    = data.azurerm_resource_group.t-clo-901-mpl-2.name
  location               = data.azurerm_resource_group.t-clo-901-mpl-2.location
  size                   = var.size
  username               = each.value.username
  ssh_key                = file("./azure.pub")
  lab_virtual_network_id = data.azurerm_dev_test_virtual_network.t-clo-901-mpl-2.id
  lab_subnet_name        = data.azurerm_subnet.t-clo-901-mpl-2.name
  storage_type           = var.storage_type
  notes                  = each.value.notes

  gallery_image_reference {
    offer     = var.offer
    publisher = var.publisher
    sku       = var.sku
    version   = var.os_version
  }

}

resource "null_resource" "claim_vm" {
  for_each = azurerm_dev_test_linux_virtual_machine.webapp

  provisioner "local-exec" {
    command = "az lab vm claim --resource-group ${each.value.resource_group_name} --lab-name ${each.value.lab_name} --name ${each.value.name}"
  }
}

resource "null_resource" "ansible_sql" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ./ansible/hosts ./ansible/init_sqldb.yaml --ssh-common-args='-o StrictHostKeyChecking=add-new'"
  }
  depends_on = [null_resource.claim_vm]
}

resource "null_resource" "ansible_webapp" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ./ansible/hosts ./ansible/init_webapp.yaml"
  }
  depends_on = [null_resource.claim_vm]
}


output "fqdn_webapp" {
  description = "fqdn of machine"
  value       = azurerm_dev_test_linux_virtual_machine.webapp["webappepi"].fqdn
}

output "fqdn_sqldb" {
  description = "fqdn of machine"
  value       = azurerm_dev_test_linux_virtual_machine.webapp["sqldb"].fqdn
}
