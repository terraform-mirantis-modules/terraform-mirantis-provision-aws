
// Map each ingress to the autoscaling groups of the nodegroups it targets.
// The gcp module builds the same mapping as mapped_instance_groups and
// mapped_target_pools; azure builds it in the other direction, handing
// lb_pool_ids to the scale sets. In all three the load balancer is given a
// group to attach, never a list of instances.
locals {
  mapped_autoscaling_groups = {
    for ik, iv in var.ingresses : ik => { for ng in iv.nodegroups : ng => module.nodegroups[ng].asg.autoscaling_group_name }
  }
}

module "ingress" {
  for_each = var.ingresses
  source   = "./modules/ingress"

  name  = each.key
  stack = var.name

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  target_autoscaling_groups = local.mapped_autoscaling_groups[each.key]

  routes = each.value.routes

  tags = merge({
    stack = var.name
    },
    var.common_tags,
    each.value.tags
  )
}

// calculated after lb is created
locals {
  // Add the lb for the lb to the ingress
  ingresses_withlb = { for k, i in var.ingresses : k => merge(i, module.ingress[k], { "lb_dns" : module.ingress[k].lb.dns_name }) }
}
