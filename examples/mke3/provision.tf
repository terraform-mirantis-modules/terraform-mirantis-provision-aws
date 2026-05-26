// cloud-init user-data for bootc-based nodes; empty string when is_bootc_based is false
locals {
  bootc_userdata = var.is_bootc_based ? templatefile("${path.module}/bootc_userdata.tpl", {
    public_key = module.key.public_key
  }) : ""
}

// locals calculated before the provision run
locals {
  // combine nodegroup definitions with AMI lookup results
  nodegroups_with_ami = { for k, ngd in var.nodegroups : k => merge({
    // WinRM defaults for non-Windows nodes
    winrm_user     = ""
    winrm_useHTTPS = false
    winrm_insecure = false
  }, ngd, {
    ami              = data.aws_ami.nodegroup[k].id
    root_device_name = data.aws_ami.nodegroup[k].root_device_name
  }) }
}

# PROVISION MACHINES/NETWORK
module "provision" {
  source = "../../"

  name        = var.name
  common_tags = local.tags
  network     = var.network

  subnets = var.subnets

  // pass nodegroups with resolved AMI and root device name
  nodegroups = { for k, ngd in local.nodegroups_with_ami : k => {
    source_image : {
      ami : ngd.ami
    }
    count : ngd.count
    type : ngd.type
    keypair_id : module.key.keypair_id
    root_device_name : ngd.root_device_name
    volume_size : ngd.volume_size
    role : ngd.role
    public : ngd.public
    user_data : var.is_bootc_based ? local.bootc_userdata : ngd.user_data
  } }

  // ingress/lb (should likely merge with an input to allow more flexibility
  ingresses = local.mke_ingresses # see mke.tf

  // firewall rules (should likely merge with an input to allow more flexibility
  securitygroups = local.mke_securitygroups # see mke.tf
}

// locals calculated after the provision module is run, but before cluster installation
locals {
  // combine each node-group definition with the provisioned nodes
  nodegroups = { for k, ngp in local.nodegroups_with_ami : k => merge({ "name" : k }, ngp, module.provision.nodegroups[k]) }
  ingresses  = { for k, i in local.mke_ingresses : k => merge({ "name" : k }, i, module.provision.ingresses[k]) }
}
