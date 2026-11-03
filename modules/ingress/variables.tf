
variable "stack" {
  description = "Stack name used for labelling resources"
  type        = string
}

variable "name" {
  description = "Names identifier for the ingress"
  type        = string
}

variable "vpc_id" {
  description = "ID for the vpc to attach to"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet ids to include"
  type        = list(string)
}

variable "target_autoscaling_groups" {
  description = "Autoscaling group name per nodegroup key, for the nodegroups this ingress targets. Nodegroups are attached as groups rather than as individual instances, matching the azure (lb_pool_ids) and gcp (target_instance_groups, target_pools) modules; a group handle is known at plan time, an instance id is not."
  type        = map(string)
}

variable "routes" {
  description = "What traffic should the ingress handle"
  type = map(object({
    port_incoming = number
    port_target   = number
    protocol      = string
  }))
}

variable "tags" {
  description = "tags to be applied to created resources"
  type        = map(string)
}
