variable "aws" {
  description = "AWS configuration"
  type = object({
    region = string
  })
  default = {
    region = "us-east-1"
  }
}

variable "name" {
  description = "Stack/cluster name used for labelling across all resources."
  type        = string
}

variable "network" {
  description = "Network configuration"
  type = object({
    cidr               = string
    enable_vpn_gateway = bool
    enable_nat_gateway = bool
  })
  default = {
    cidr               = "172.31.0.0/16"
    enable_vpn_gateway = false
    enable_nat_gateway = false
  }
}

variable "subnets" {
  description = "Subnet definitions; each entry maps a CIDR to a set of nodegroups."
  type = map(object({
    cidr       = string
    nodegroups = list(string)
    private    = bool
  }))
  default = {}
}

variable "nodegroups" {
  description = "A map of node group definitions. AMI selection is done via name filter and owner rather than a hardcoded ID, so the most recent matching image is always used."
  type = map(object({
    // AWS AMI name glob pattern, e.g. "Rocky-9-EC2-Base-9.*x86_64*"
    ami_name = string
    // AWS account ID that owns the AMI, e.g. "792107900699" for RESF (Rocky Linux)
    ami_owner = string

    // SSH connection details matching the AMI's default user.
    ssh_user = string
    ssh_port = optional(number, 22)

    type        = string
    count       = number
    volume_size = number
    role        = string
    public      = bool
    user_data   = optional(string, "")
  }))
}

variable "extra_tags" {
  description = "Additional tags applied to all provisioned resources."
  type        = map(string)
  default     = {}
}

variable "ssh_pk_location" {
  description = "Directory in which to write the generated SSH private key file. Defaults to ./ssh-keys."
  type        = string
  default     = ""
}
