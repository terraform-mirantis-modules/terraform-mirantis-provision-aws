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
  // combine ami/platform data (and windows user data, if applicable). winrm
  // platforms' generated user_data is a fixed requirement (Administrator
  // password reset + WinRM-over-HTTPS listener) launchpad cannot connect
  // without, so var.user_data is appended after it rather than replacing
  // it; non-winrm platforms have no fixed requirement, so var.user_data is
  // used as-is.
  platform_with_ami = merge(
    local.platform,
    data.aws_ami.ami,
    { key : var.platform_key, ami : data.aws_ami.ami.id },
    {
      user_data = local.platform.connection == "winrm" ? join("\n", compact([
        templatefile("${path.module}/userdata_windows.tpl", {
          windows_administrator_password = var.windows_password
        }),
        var.user_data
      ])) : var.user_data
    }
  )
}
