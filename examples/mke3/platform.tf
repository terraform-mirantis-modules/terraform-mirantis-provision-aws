// variables calculated before ami data is retrieved
locals {
  // collect distinct platform keys from nodegroups that use platform-based AMI selection
  unique_used_platforms = distinct([for k, ngd in var.nodegroups : ngd.platform if ngd.platform != null])
}

module "platform" {
  count  = length(local.unique_used_platforms)
  source = "../../modules/platform"

  platform_key     = local.unique_used_platforms[count.index]
  windows_password = var.windows_password
}

// variables calculated after ami data is pulled
locals {
  // convert platform ami list to a map keyed by platform name
  platforms_with_ami = { for k, p in local.unique_used_platforms : p => module.platform[k].platform }
}
