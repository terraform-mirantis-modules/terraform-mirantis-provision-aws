data "aws_instances" "nodes" {
  depends_on = [module.mg]

  instance_tags = {
    "aws:autoscaling:groupName" = module.mg.autoscaling_group_id
  }

  instance_state_names = ["pending", "running"]
}

data "aws_instance" "node" {
  depends_on = [module.mg, data.aws_instances.nodes]

  count = var.node_count // this is actually risky, but TF won't let us count the number of IDs in the instances resource

  instance_id = data.aws_instances.nodes.ids[count.index]
}


// Calico (and MKE's bundled overlay) route pod traffic natively, without
// encapsulation, between nodes that land in the *same* subnet (see Calico's
// "CrossSubnet" IPIP/VXLAN mode). AWS drops that traffic by default because
// each ENI enforces a source/destination IP check that rejects packets whose
// source/destination doesn't match the ENI's assigned address (the pod IP,
// in this case). This only bites once two nodes of the same role share a
// subnet/AZ (e.g. 3 managers in one subnet) - a single-node-per-subnet
// layout never triggers native routing, which is why 1 manager + 1 worker
// "works". ASG-launched instances have no Terraform-managed resource for
// their auto-created primary ENI, so this has to be disabled out-of-band.
resource "null_resource" "disable_source_dest_check" {
  count = var.node_count

  triggers = {
    instance_id = data.aws_instance.node[count.index].id
  }

  provisioner "local-exec" {
    command = "aws ec2 modify-instance-attribute --region ${data.aws_region.current.region} --instance-id ${data.aws_instance.node[count.index].id} --no-source-dest-check"
  }
}

data "aws_region" "current" {}
