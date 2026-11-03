// An instance profile attached to every nodegroup.
//
// The module takes instance_profile_name and sets
// create_iam_instance_profile = false on the autoscaling group, so the
// profile has to exist before the nodegroups are built. Every real consumer
// of this module passes one (launchpad's aws-simple and aws-complete
// examples, and the mke-demo stacks), so an example that leaves it null
// never exercises that wiring.
//
// The policy below is deliberately minimal: the describe calls an
// in-cluster cloud provider needs to enumerate its own instances. Add to it
// for workloads that need more; do not widen it here.

data "aws_iam_policy_document" "assume" {
  count = var.create_instance_profile ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "nodes" {
  count = var.create_instance_profile ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ec2:DescribeTags",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "nodes" {
  count = var.create_instance_profile ? 1 : 0

  name               = "${var.name}-nodes"
  assume_role_policy = data.aws_iam_policy_document.assume[0].json
  tags               = local.tags
}

resource "aws_iam_role_policy" "nodes" {
  count = var.create_instance_profile ? 1 : 0

  name   = "${var.name}-nodes"
  role   = aws_iam_role.nodes[0].id
  policy = data.aws_iam_policy_document.nodes[0].json
}

resource "aws_iam_instance_profile" "nodes" {
  count = var.create_instance_profile ? 1 : 0

  name = "${var.name}-nodes"
  role = aws_iam_role.nodes[0].name
  tags = local.tags
}

locals {
  instance_profile_name = var.create_instance_profile ? aws_iam_instance_profile.nodes[0].name : null
}
