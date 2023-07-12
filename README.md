# Introduction:

The module is used to deploy azure container registries over terraform with a default setup (Infrastructure as Code).

> **_NOTE:_** The required providers, providers configuration and terraform version are maintained in the user's configuration and are not maintained in the modules themselves.

# Example Use of Module:

    module "bastion-vm" {
    source = "github.com/la-cc/terraform-azure-bastion-vm?ref=1.0.0"
    
        resource_group_name = "rg-bastion-vm"
        name = "bastion-vm"
    
    }
