
output "nodes" {
  description = "Nodegroups with provisioned node details"
  value       = local.nodegroups
  sensitive   = true
}

output "ingresses" {
  description = "Ingresses with DNS information"
  value       = local.ingresses
}

output "platforms" {
  description = "Resolved platform/AMI data"
  value       = local.platforms_with_ami
  sensitive   = true
}
