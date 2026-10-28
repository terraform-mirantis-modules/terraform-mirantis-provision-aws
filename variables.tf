
variable "name" {
  description = "cluster/stack name used for identification"
  type        = string
}

# ===  Networking ===
variable "network" {
  description = "Network configuration"
  type = object({
    enable_nat_gateway = bool
    enable_vpn_gateway = bool
    cidr               = string
    tags               = optional(map(string), {})
  })
  default = {
    enable_nat_gateway = false
    enable_vpn_gateway = false
    cidr               = "172.31.0.0/16"
    tags               = {}
  }
}

# === subnets ===
variable "subnets" {
  description = "The subnets configuration"
  type = map(object({
    cidr       = string
    nodegroups = list(string)
    private    = bool
  }))
  default = {}
}

# === Machines ===

variable "nodegroups" {
  description = "A map of machine group definitions"
  # Fields are grouped by portability. Common fields have the same name and
  # meaning in the aws, azure and gcp provision modules, so a nodegroup
  # definition moves between clouds by changing only the cloud-specific
  # fields.
  type = map(object({
    # --- Common (aws, azure, gcp) ---
    type                  = string
    count                 = number
    volume_size           = number
    volume_encrypted      = optional(bool, true)
    role                  = string
    public                = bool
    user_data             = string
    instance_profile_name = optional(string)
    tags                  = optional(map(string), {})
    # true: launch template changes roll (replace) running instances.
    # false (default): they reach new instances only.
    instance_refresh = optional(bool, false)

    # --- AWS-specific ---
    # Each cloud's module shapes its image reference differently.
    source_image = object({
      ami = string
    })
    keypair_id       = string
    root_device_name = string
    # An AWS KMS key ARN/ID; requires volume_encrypted = true.
    volume_kms_key_id = optional(string)
    # IMDS options; omitted fields keep IMDSv2 required, hop limit 1. Hop
    # limit 2 lets pods off the host network read the instance profile's
    # credentials.
    metadata_options = optional(object({
      http_endpoint               = optional(string, "enabled")
      http_put_response_hop_limit = optional(number, 1)
      http_tokens                 = optional(string, "required")
    }), {})
  }))
  default = {}

  validation {
    # EC2 ignores a KMS key when encryption is off, so the combination would
    # silently produce an unencrypted volume.
    condition = alltrue([
      for k, ng in var.nodegroups :
      ng.volume_kms_key_id == null || ng.volume_encrypted
    ])
    error_message = "A nodegroup setting volume_kms_key_id must also set volume_encrypted = true; EC2 ignores the key when encryption is disabled."
  }
}

# === Firewalls ===

variable "securitygroups" {
  description = "VPC Network Security group configuration"
  type = map(object({
    description = string
    nodegroups  = list(string) # which nodegroups should get attached to the sg?

    ingress_ipv4 = optional(list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      self        = bool
    })), [])
    egress_ipv4 = optional(list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      self        = bool
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}

# === Ingresses ===

variable "ingresses" {
  description = "Configure ingress (ALB) for specific nodegroup roles"
  type = map(object({
    description = string
    nodegroups  = list(string) # which nodegroups should get attached to the ingress

    routes = map(object({
      port_incoming = number
      port_target   = number
      protocol      = string
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

# === Common ===

variable "common_tags" {
  description = "Tags that should be applied to all resources created"
  type        = map(string)
  default     = {}
}
