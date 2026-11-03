// Resolve each nodegroup against its platform entry. The platform supplies
// the ami, root_device_name and the connection metadata; for winrm platforms
// it also supplies the generated WinRM bootstrap user_data, so a caller
// user_data is only used when the platform did not produce one.
locals {
  nodegroups_resolved = { for k, ngd in var.nodegroups : k => merge(
    ngd,
    local.platforms_with_ami[ngd.platform],
  ) }
}

locals {
  windows_nodegroups = [for k, ng in local.nodegroups_resolved : k if ng.connection == "winrm"]
  linux_nodegroups   = [for k, ng in local.nodegroups_resolved : k if ng.connection != "winrm"]

  securitygroups = {
    // Separate groups per protocol rather than one permissive group, so that
    // the rules a windows stack actually needs are visible and so that the
    // port-range form (5985-5986) is exercised.
    "internal" = {
      description = "Unrestricted traffic between cluster nodes"
      nodegroups  = keys(var.nodegroups)
      ingress_ipv4 = [{
        description = "All traffic between nodes"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        self        = true
        cidr_blocks = []
      }]
      egress_ipv4 = [{
        description = "All outbound"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        self        = false
        cidr_blocks = ["0.0.0.0/0"]
      }]
    }

    "ssh" = {
      description = "SSH to the linux nodes"
      nodegroups  = local.linux_nodegroups
      ingress_ipv4 = [{
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        self        = false
        cidr_blocks = ["0.0.0.0/0"]
      }]
      egress_ipv4 = []
    }

    "winrm" = {
      description = "WinRM to the windows nodes"
      nodegroups  = local.windows_nodegroups
      ingress_ipv4 = [
        {
          // 5985 (HTTP) and 5986 (HTTPS) as one range: the module renders a
          // single rule with from_port != to_port.
          description = "WinRM"
          from_port   = 5985
          to_port     = 5986
          protocol    = "tcp"
          self        = false
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "RDP"
          from_port   = 3389
          to_port     = 3389
          protocol    = "tcp"
          self        = false
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_ipv4 = []
    }
  }

  // One ingress across both roles, so the load balancer attaches more than a
  // single nodegroup and the attachment fan-out is exercised.
  cluster_ingresses = {
    "cluster" = {
      description = "Cluster entrypoint"
      nodegroups  = keys(var.nodegroups)
      routes = {
        https = {
          port_incoming = 443
          port_target   = 443
          protocol      = "TCP"
        }
      }
      tags = local.tags
    }
  }
}

module "provision" {
  source = "../../"

  name        = var.name
  common_tags = local.tags
  network     = var.network
  subnets     = var.subnets

  nodegroups = { for k, ngd in local.nodegroups_resolved : k => {
    source_image = {
      ami = ngd.ami
    }
    keypair_id       = module.key.keypair_id
    type             = ngd.type
    count            = ngd.count
    root_device_name = ngd.root_device_name
    volume_size      = ngd.volume_size
    role             = ngd.role
    public           = ngd.public
    user_data        = ngd.user_data
    tags             = local.tags
  } }

  securitygroups = local.securitygroups
  ingresses      = local.cluster_ingresses
}

// Merge provisioned node data back with the resolved definitions, so the
// outputs carry both the connection metadata and the live addresses.
locals {
  nodegroups = { for k, ngd in local.nodegroups_resolved : k => merge(
    ngd,
    module.provision.nodegroups[k],
  ) }

  ingresses = module.provision.ingresses
}
