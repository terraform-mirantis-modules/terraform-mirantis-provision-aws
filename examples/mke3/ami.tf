// Look up AMIs for nodegroups that specify ami_id directly.
// Filtered to only those entries so platform-based nodegroups are unaffected.
data "aws_ami" "nodegroup" {
  for_each = { for k, ng in var.nodegroups : k => ng if ng.ami_id != null }

  most_recent = true
  owners      = [each.value.ami_owner]

  filter {
    name   = "image-id"
    values = [each.value.ami_id]
  }
}
