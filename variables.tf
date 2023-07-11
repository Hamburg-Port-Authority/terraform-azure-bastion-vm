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
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group name."
}

variable "address_space" {

  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Address space for the virtual network."
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network."
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

variable "tags" {
  type = map(string)
  default = {
    TF-Managed  = "true"
    TF-Worfklow = ""
    Maintainer  = ""

  }
  description = "A mapping of tags to assign to the resource."
}
