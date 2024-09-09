# Provisioning AWS infrastructure for Mirantis Launchpad and K0s

This repository contains Terraform configuration files for provisioning resources on Amazon Web Services(AWS) dedicated to support Mirantis products.

## Prerequisites

Before you begin, ensure that you have the following:

- Terraform installed on your local machine
- AWS account and project set up


## Usage
```hcl
module "provision" {
  source = "terraform-mirantis-modules/provision-aws/mirantis"

  name        = var.name
  common_tags = local.tags

  // network information
  network = var.network
  subnets = var.subnets

  // pass in a mix of nodegroups with the platform information
  nodegroups = { for k, ngd in local.nodegroups_wplatform : k => {
    ami : ngd.ami
    count : ngd.count
    type : ngd.type
    keypair_id : module.key.keypair_id
    root_device_name : ngd.root_device_name
    volume_size : ngd.volume_size
    role : ngd.role
    public : ngd.public
    user_data : ngd.user_data
  } }

  ingresses = local.launchpad_ingresses # see launchpad.tf

  securitygroups = local.launchpad_securitygroups # see launchpad.tf
}
```

## Examples
If you want to see full example, check the [examples folder](./examples).

## License

This project is licensed under the [MIT License].
