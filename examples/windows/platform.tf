// variables calculated before ami data is retrieved
locals {
  // collect distinct platform keys from nodegroups
  unique_used_platforms = distinct([for k, ngd in var.nodegroups : ngd.platform])
}

// The platform module turns a platform key into an AMI and the connection
// metadata for it. For winrm platforms it also renders the WinRM bootstrap
// user_data (Administrator password reset, WinRM-over-HTTPS listener), which
// is why windows_password is passed here rather than only into the nodegroup.
module "platform" {
  count  = length(local.unique_used_platforms)
  source = "../../modules/platform"

  platform_key     = local.unique_used_platforms[count.index]
  windows_password = local.windows_password
}

// variables calculated after ami data is pulled
locals {
  // convert platform ami list to a map keyed by platform name
  platforms_with_ami = { for k, p in local.unique_used_platforms : p => module.platform[k].platform }
}
