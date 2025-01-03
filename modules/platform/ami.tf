locals {
  platform = local.lib_platform_definitions[var.platform_key]
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = [local.platform.owner]
  filter {
    name   = "name"
    values = [local.platform.ami_name]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// variables calculated after ami data is pulled
locals {
  // combine ami/plaftorm data (and windows user data)
  platform_with_ami = merge(
    local.platform,
    data.aws_ami.ami,
    { key : var.platform_key, ami : data.aws_ami.ami.id }
  )
}
