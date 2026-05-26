
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
  description = "Stack/cluster name, used in labelling across the stack."
  type        = string
}

variable "network" {
  description = "VPC network configuration"
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
  description = "Subnet configuration"
  type = map(object({
    cidr       = string
    nodegroups = list(string)
    private    = bool
  }))
  default = {}
}

variable "nodegroups" {
  description = "A map of machine group definitions. Supported roles: controller, worker, controller+worker."
  type = map(object({
    platform    = string
    type        = string
    count       = number
    volume_size = number
    role        = string # controller | worker | controller+worker
    public      = bool
    user_data   = optional(string, "")
  }))
}

variable "k0sctl" {
  description = "k0sctl / k0s cluster configuration"
  type = object({
    k0s_version = string # e.g. "v1.30.2+k0s.0"
  })
}

variable "extra_tags" {
  description = "Extra tags applied to all provisioned resources."
  type        = map(string)
  default     = {}
}

variable "ssh_pk_location" {
  description = "Directory to write the generated SSH private key. Defaults to ./ssh-keys/."
  type        = string
  default     = ""
}
