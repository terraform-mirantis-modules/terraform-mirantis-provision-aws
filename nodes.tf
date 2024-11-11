

locals {
  // collect subnets per nodegroup where the nodegroup name matches at least one of the subnet nodegroup names, inclusing some wildcard and regex options.
  // @NOTE try() around the regex avoids errors if the subnet nodegroup is not a valid regex pattern.
  vpc_subnets_to_ngs = { for nk, ng in var.nodegroups : nk => [for sk, s in var.subnets : s.cidr if length([for sng in s.nodegroups : sng if sng == "*" || sng == nk || try(length(regexall(sng, nk)) > 0, false)]) > 0] }

}

data "aws_subnets" "all" {
  depends_on = [module.vpc]
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

data "aws_subnet" "all" {
  count = length(var.subnets)
  id    = data.aws_subnets.all.ids[count.index]
}

locals {
  map_subnets_to_ngs = { for k, ngv in local.vpc_subnets_to_ngs : k => flatten([for dps in data.aws_subnet.all : dps.id if contains(ngv, dps.cidr_block)]) }
}


module "nodegroups" {
  for_each = var.nodegroups

  source = "./modules/nodegroup"

  name = "${var.name}-${each.key}"

  source_image          = each.value.source_image
  type                  = each.value.type
  node_count            = each.value.count
  root_device_name      = each.value.root_device_name
  volume_size           = each.value.volume_size
  user_data             = each.value.user_data
  key_pair              = each.value.keypair_id
  instance_profile_name = each.value.instance_profile_name

  subnets         = local.map_subnets_to_ngs[each.key]
  security_groups = [for k, sg in local.securitygroups_with_sg : sg.id if contains(sg.nodegroups, each.key)] # attach any sgs listed for this nodegroup

  tags = merge({
    stack = var.name
    },
    var.common_tags,
    each.value.tags
  )
}

// locals created after node groups are provisioned.
locals {
  // combine node-group asg & node information after creation
  nodegroups = { for k, ng in var.nodegroups : k => merge(ng, {
    nodes : module.nodegroups[k].nodes
  }) }

  // a safer nodegroup listing that doesn't have any sensitive data.
  nodegroups_safer = { for k, ng in var.nodegroups : k => merge(ng, {
    nodes : [for j, i in module.nodegroups[k].nodes : {
      nodegroup       = k
      index           = j
      id              = "${k}-${j}"
      label           = "${var.name}-${k}-${j}"
      instance_id     = i.instance_id
      private_ip      = i.private_ip
      private_dns     = i.private_dns
      private_address = trimspace(coalesce(i.private_dns, i.private_ip, " "))
      public_ip       = i.public_ip
      public_dns      = i.public_dns
      public_address  = trimspace(coalesce(i.public_dns, i.public_ip, " "))
    }]
  }) }
}

