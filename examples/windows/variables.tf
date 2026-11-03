variable "name" {
  description = "Stack name used to label all provisioned resources."
  type        = string
}

variable "aws" {
  description = "AWS provider configuration."
  type = object({
    region = string
  })
}

variable "network" {
  description = "Network configuration."
  type = object({
    cidr               = string
    enable_nat_gateway = bool
    enable_vpn_gateway = bool
  })
  default = {
    cidr               = "172.31.0.0/16"
    enable_nat_gateway = false
    enable_vpn_gateway = false
  }
}

variable "subnets" {
  description = "Subnet configuration."
  type = map(object({
    cidr       = string
    nodegroups = list(string)
    private    = bool
  }))
}

variable "nodegroups" {
  description = "Machine group definitions. Every entry selects its image through the platform library, so that winrm platforms bring their own connection metadata (winrm_user, winrm_useHTTPS, winrm_insecure) and their WinRM bootstrap user_data."
  type = map(object({
    platform    = string
    type        = string
    count       = number
    volume_size = number
    role        = string
    public      = bool
    user_data   = optional(string, "")
  }))

  validation {
    condition     = length([for k, ng in var.nodegroups : k if startswith(ng.platform, "windows")]) > 0
    error_message = "This example exists to exercise the windows/winrm path; at least one nodegroup must use a windows_* platform. Use examples/mke3 for linux-only stacks."
  }
}

variable "ssh_pk_location" {
  description = "Directory to write the generated SSH private key into. Defaults to ./ssh-keys."
  type        = string
  default     = ""
}

variable "extra_tags" {
  description = "Tags applied to every resource that supports them."
  type        = map(string)
  default     = {}
}
