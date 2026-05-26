
// Resolve each unique platform key to an AMI + connection config.
// Only platforms actually referenced by a nodegroup are looked up.
locals {
  unique_used_platforms = distinct([for ngd in var.nodegroups : ngd.platform])
}

module "platform" {
  count  = length(local.unique_used_platforms)
  source = "../../modules/platform"

  platform_key = local.unique_used_platforms[count.index]
}

locals {
  platforms_with_ami = { for k, p in local.unique_used_platforms : p => module.platform[k].platform }
}
