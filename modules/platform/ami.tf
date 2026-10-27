locals {
  platform = local.lib_platform_definitions[var.platform_key]
}

// When var.ami is set the lookup is skipped entirely, so a pinned AMI never
// drifts with new image releases.
data "aws_ami" "ami" {
  count = var.ami == null ? 1 : 0

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
  // null when an ami override was given, as the lookup is then not run.
  ami_data = one(data.aws_ami.ami)

  // combine ami/platform data (and windows user data, if applicable). winrm
  // platforms' generated user_data is a fixed requirement (Administrator
  // password reset + WinRM-over-HTTPS listener) launchpad cannot connect
  // without, so var.user_data is appended after it rather than replacing
  // it; non-winrm platforms have no fixed requirement, so var.user_data is
  // used as-is.
  platform_with_ami = merge(
    local.platform,
    local.ami_data == null ? {} : local.ami_data,
    { key : var.platform_key, ami : coalesce(var.ami, try(local.ami_data.id, null)) },
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
