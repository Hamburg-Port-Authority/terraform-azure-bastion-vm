variable "name" {
  type        = string
  default     = "bastion"
  description = "Name of the bastion host."

}

variable "disable_password_authentication" {
  type        = bool
  default     = true
  description = "Disable password authentication for the VM."

}

variable "vm_size" {

  type        = string
  default     = "Standard_D2s_v3"
  description = "The size of the virtual machine."

}

variable "allocation_method" {
  type        = string
  default     = "Static"
  description = "The allocation method to use for this Public IP Address. Possible values are Static or Dynamic."

}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "The SKU of the Public IP. Possible values are Basic and Standard."

}
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group name."
}

variable "address_space" {

  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Address space for the virtual network."
}

variable "address_prefixes" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "The address prefixes for the subnet"

}

variable "linux_vm_admin_username" {
  type    = string
  default = "sysadmin"
}

variable "trusted_networks" {
  type    = map(string)
  default = {}
}

variable "storage_image_reference" {

  type = list(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))

  default = [{
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }]
  description = "Values for the storage image reference."

}


variable "custom_source_address_prefix" {
  description = "The source address prefix to use for the security rule."
  type        = string
}


variable "tags" {
  type = map(string)
  default = {
    TF-Managed  = "true"
    TF-Worfklow = ""
    Maintainer  = ""

  }
  description = "A mapping of tags to assign to the resource."
}
