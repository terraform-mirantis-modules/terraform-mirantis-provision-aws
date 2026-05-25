output "nodes" {
  description = "Nodegroups with provisioned node details"
  value       = local.nodegroups
  sensitive   = true
}

output "amis" {
  description = "Resolved AMI details for each nodegroup"
  value = { for k, ami in data.aws_ami.nodegroup : k => {
    id               = ami.id
    name             = ami.name
    root_device_name = ami.root_device_name
  } }
}

output "ssh_private_key_path" {
  description = "Path to the generated SSH private key"
  value       = abspath(local_sensitive_file.ssh_private_key.filename)
}
