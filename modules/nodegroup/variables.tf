
variable "name" {
  description = "Node Group key"
  type        = string
}

variable "source_image" {
  description = "The source image to use for the machine"
  type = object({
    ami = string
  })
}

variable "type" {
  description = "Instance Type/Size"
  type        = string
}

variable "public" {
  description = "Should the nodes receive a public IP address"
  type        = bool
  default     = true
}

variable "node_count" {
  description = "Number of machines to create"
  type        = number
}

variable "root_device_name" {
  description = "root device name for the primary volume"
  type        = string
}

variable "volume_size" {
  description = "Size of primary volume"
  type        = number
}

variable "volume_encrypted" {
  description = "Should the primary volume be EBS encrypted"
  type        = bool
  default     = true
}

variable "volume_kms_key_id" {
  description = "KMS key ARN/ID to encrypt the primary volume with; null uses the account's default EBS key (aws/ebs, or the account default set via ModifyEbsDefaultKmsKeyId). A customer-managed key must allow kms:CreateGrant for AWSServiceRoleForAutoScaling, otherwise instances fail to launch with Client.InternalError and the failure surfaces as an ASG scaling error rather than a terraform error."
  type        = string
  default     = null

  validation {
    # EC2 ignores a key id when encryption is off, so the combination is a
    # silent no-op rather than an error at the API.
    condition     = var.volume_kms_key_id == null || var.volume_encrypted
    error_message = "volume_kms_key_id requires volume_encrypted = true; EC2 ignores the key when encryption is disabled."
  }
}

variable "subnets" {
  description = "Subnet list to attach machines to"
  type        = list(string)
}

variable "security_groups" {
  description = "Security group ids"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "user_data" {
  description = "User data for the machines (unencoded)."
  type        = string
}

variable "key_pair" {
  description = "AWS KeyPair name for nodes"
  type        = string
}

variable "instance_profile_name" {
  description = "Existing instance profile name to be attached to the nodes"
}

variable "metadata_options" {
  description = "Instance metadata service options. The default matches terraform-aws-modules/autoscaling's: IMDSv2 required, hop limit 1. Raise http_put_response_hop_limit to 2 for pods (not on the host network) to reach IMDS, e.g. to use the instance profile from a CSI controller."
  type = object({
    http_endpoint               = optional(string, "enabled")
    http_put_response_hop_limit = optional(number, 1)
    http_tokens                 = optional(string, "required")
  })
  default  = {}
  nullable = false
}

variable "instance_refresh" {
  description = "Roll the group's instances when its launch template changes (AWS always starts a refresh on a launch template change while instance_refresh is configured). Off by default: an apply that touches the launch template (a new instance profile, IMDS options, user data) must not replace running nodes, which for a cluster means losing it. When off, launch template changes reach new instances only."
  type        = bool
  default     = false
  nullable    = false
}
