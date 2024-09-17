
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
