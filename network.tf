resource "azurerm_virtual_network" "main" {
  name                = format("vnet-%s", var.name)
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = var.address_space
}

resource "azurerm_subnet" "main" {
  name                 = var.name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = format("vnet-%s", var.name)
  address_prefixes     = var.address_prefixes

  depends_on = [azurerm_virtual_network.main]
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
  source_address_prefix       = var.custom_source_address_prefix != null ? var.custom_source_address_prefix : "*"
  destination_address_prefix  = "*"
}


resource "azurerm_public_ip" "main" {
  name                = var.name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = var.sku

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

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}
