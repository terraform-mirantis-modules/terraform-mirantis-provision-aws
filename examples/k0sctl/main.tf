
resource "time_static" "now" {}

locals {
  tags = merge(
    {
      "stack"   = var.name
      "created" = time_static.now.rfc3339
    },
    var.extra_tags
  )
}
