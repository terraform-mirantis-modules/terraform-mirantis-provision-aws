// Look up each nodegroup's AMI by its known ID so we can retrieve metadata
// (root_device_name) without requiring the caller to supply it manually.
data "aws_ami" "nodegroup" {
  for_each = var.nodegroups

  most_recent = true
  owners      = [each.value.ami_owner]

  filter {
    name   = "image-id"
    values = [each.value.ami_id]
  }
}
