resource "azurerm_virtual_network" "main" {
  name                = format("vnet-%s", var.name)
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = var.address_space
}

resource "azurerm_subnet" "main" {
  name                 = var.name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
}

resource "azurerm_network_security_group" "main" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  tags                = var.tags
}

resource "azurerm_network_security_rule" "allow_ssh_to_bastion_host_from_trusted_networks" {
  name                        = "AllowSSH"
  resource_group_name         = data.azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = azurerm_network_interface.main.public_ip_address_id
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_password" "main" {
  length  = 32
  special = true
}

resource "azurerm_public_ip" "main" {
  name                = var.name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  allocation_method = var.allocation_method

  tags = var.tags
}

resource "azurerm_network_interface" "main" {

  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  name                    = var.name
  internal_dns_name_label = var.name
  enable_ip_forwarding    = false

  ip_configuration {
    primary                       = true
    name                          = "primary"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = var.tags
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
  storage_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11-backports-gen2"
    version   = "latest"
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
