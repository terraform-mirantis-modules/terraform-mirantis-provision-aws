// Permissive security group — tighten per your environment.
locals {
  securitygroups = {
    "permissive" = {
      description = "Common SG for all cluster nodes"
      nodegroups  = [for k, ng in var.nodegroups : k]
      ingress_ipv4 = [
        {
          description = "Permissive internal traffic"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          self        = true
          cidr_blocks = []
        },
        {
          description = "SSH from anywhere"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          self        = false
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_ipv4 = [
        {
          description = "Permissive outgoing traffic"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          self        = false
        }
      ]
    }
  }
}

module "provision" {
  source = "../../"

  name        = var.name
  common_tags = local.tags
  network     = var.network
  subnets     = var.subnets

  nodegroups = { for k, ng in var.nodegroups : k => {
    source_image = {
      ami = data.aws_ami.nodegroup[k].id
    }
    count            = ng.count
    type             = ng.type
    keypair_id       = module.key.keypair_id
    root_device_name = data.aws_ami.nodegroup[k].root_device_name
    volume_size      = ng.volume_size
    role             = ng.role
    public           = ng.public
    user_data        = ng.user_data
  } }

  securitygroups = local.securitygroups
  ingresses      = {}
}

// Merge provisioned node data back with the input definitions for outputs.
locals {
  nodegroups = { for k, ng in var.nodegroups : k => merge(
    { name = k },
    ng,
    module.provision.nodegroups[k],
    { ssh_key_path = abspath(local_sensitive_file.ssh_private_key.filename) }
  ) }
}
