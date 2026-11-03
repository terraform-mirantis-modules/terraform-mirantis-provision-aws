
resource "aws_lb" "this" {
  name               = "${var.stack}-${var.name}-lb"
  internal           = false
  load_balancer_type = "network"

  subnets = var.subnet_ids

  tags = merge({
    ingress = var.name
    },
    var.tags
  )
}

resource "aws_lb_target_group" "targets" {
  for_each = var.routes

  name = "${var.stack}-${var.name}-${each.key}"

  vpc_id   = var.vpc_id
  port     = each.value.port_target
  protocol = each.value.protocol

  tags = merge({
    ingress = var.name
    target  = each.key
    },
    var.tags
  )
}

resource "aws_lb_listener" "listeners" {
  for_each = var.routes

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port_incoming
  protocol          = each.value.protocol

  default_action {
    target_group_arn = aws_lb_target_group.targets[each.key].arn
    type             = "forward"
  }
}

// === attach each targeted nodegroup to every route's target group ===

locals {

  // Keyed by route and nodegroup. Both come from configuration, so the
  // addresses are known at plan time and a given nodegroup keeps the same
  // address regardless of how many instances it holds or what order they
  // are listed in.
  target_groups = merge([for rk, r in var.routes : {
    for nk, asg in var.target_autoscaling_groups : "${rk}:${nk}" => {
      target_group_arn = aws_lb_target_group.targets[rk].arn,
      asg_name         = asg,
    }
  }]...)

}

// The autoscaling group registers its own instances with the target group on
// the target group's port (port_target) and deregisters them on scale-in, so
// membership follows the group with no terraform run. This matches how the
// azure and gcp modules attach nodegroups to their load balancers: azure
// hands lb_pool_ids to the scale set, gcp hands instance groups and target
// pools to its ingress. None of the three addresses individual instances.
resource "aws_autoscaling_attachment" "nodegroups" {
  for_each = local.target_groups

  autoscaling_group_name = each.value.asg_name
  lb_target_group_arn    = each.value.target_group_arn
}
