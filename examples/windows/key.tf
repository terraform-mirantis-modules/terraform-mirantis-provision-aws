# RSA, not ed25519.
#
# EC2 rejects an ed25519 key pair on a Windows AMI at launch template
# validation time:
#
#   ValidationError: You must use a valid fully-formed launch template.
#   ED25519 key pairs are not supported with Windows AMIs.
#
# The error surfaces as an autoscaling group creation failure, so it is only
# reached on apply. One key is shared by every nodegroup in the stack, so the
# whole stack uses RSA; linux nodes accept it. launchpad does the same, passing
# ssh_key_algorithm = "rsa" for its windows and FIPS suites.

module "key" {
  source = "../../modules/key/rsa"

  name = "${var.name}-common"
  tags = local.tags
}

locals {
  pk_path = var.ssh_pk_location != "" ? join("/", [var.ssh_pk_location, "${var.name}-common.pem"]) : "./ssh-keys/${var.name}-common.pem"
}

resource "local_sensitive_file" "ssh_private_key" {
  content              = module.key.private_key
  filename             = local.pk_path
  file_permission      = "0600"
  directory_permission = "0700"
}
