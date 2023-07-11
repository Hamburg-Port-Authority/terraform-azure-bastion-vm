resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_password" "main" {
  length  = 32
  special = true
}

resource "azurerm_virtual_machine" "main" {

  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  name                         = azurerm_network_interface.main.name
  network_interface_ids        = [azurerm_network_interface.main.id]
  primary_network_interface_id = azurerm_network_interface.main.id
  vm_size                      = var.vm_size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = format("%s-os", azurerm_network_interface.main.name)
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # az vm image list --offer Debian --all --output table --location westeurope
  dynamic "storage_image_reference" {
    for_each = var.storage_image_reference
    iterator = it

    content {
      version   = it.value.version
      sku       = it.value.sku
      publisher = it.value.publisher
      offer     = it.value.offer
    }
  }

  os_profile {
    computer_name  = azurerm_network_interface.main.name
    admin_username = var.linux_vm_admin_username
    admin_password = random_password.main.result
  }

  os_profile_linux_config {
    disable_password_authentication = var.disable_password_authentication

    ssh_keys {
      path     = "/home/${var.linux_vm_admin_username}/.ssh/authorized_keys"
      key_data = tls_private_key.main.public_key_openssh
    }
  }

  tags = var.tags
}


resource "azurerm_managed_disk" "main" {
  name                 = format("disk-1-%s", var.name)
  location             = data.azurerm_resource_group.main.location
  resource_group_name  = data.azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 1024
}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  managed_disk_id    = azurerm_managed_disk.main.id
  virtual_machine_id = azurerm_virtual_machine.main.id
  lun                = "10"
  caching            = "ReadWrite"
}
