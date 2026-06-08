// Platform definitions are split across platforms_<family>.tf files.
// This file merges them into the single map consumed by ami.tf.
// Credit to @jcarrol for the original idea of structuring platform definitions as a named local map.
locals {
  lib_platform_definitions = merge(
    local.lib_platforms_alma,
    local.lib_platforms_centos,
    local.lib_platforms_oracle,
    local.lib_platforms_rhel,
    local.lib_platforms_rocky,
    local.lib_platforms_sles,
    local.lib_platforms_ubuntu,
    local.lib_platforms_windows,
  )
}
