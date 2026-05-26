
// Combine each nodegroup definition with its resolved platform/AMI data.
locals {
  nodegroups_wplatform = { for k, ngd in var.nodegroups : k => merge(ngd, local.platforms_with_ami[ngd.platform]) }
}

// PROVISION MACHINES / NETWORK
module "provision" {
  source = "../../"

  name        = var.name
  common_tags = local.tags
  network     = var.network
  subnets     = var.subnets

  nodegroups = { for k, ngd in local.nodegroups_wplatform : k => {
    source_image : {
      ami : ngd.ami
    }
    count                 = ngd.count
    type                  = ngd.type
    keypair_id            = module.key.keypair_id
    root_device_name      = ngd.root_device_name
    volume_size           = ngd.volume_size
    role                  = ngd.role
    public                = ngd.public
    user_data             = ngd.user_data
    instance_profile_name = null
    tags                  = {}
  } }

  ingresses      = local.k0sctl_ingresses
  securitygroups = local.k0sctl_securitygroups
}

// Post-provision: merge platform data with provisioned node details.
locals {
  nodegroups = { for k, ngp in local.nodegroups_wplatform : k => merge({ "name" : k }, ngp, module.provision.nodegroups[k]) }
  ingresses  = { for k, i in local.k0sctl_ingresses : k => merge({ "name" : k }, i, module.provision.ingresses[k]) }
}
