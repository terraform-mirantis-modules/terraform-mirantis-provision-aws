# Provisioning AWS infrastructure for Mirantis Launchpad and K0s

This repository contains Terraform configuration files for provisioning resources on Amazon Web Services(AWS) dedicated to support Mirantis products.

## Prerequisites

Before you begin, ensure that you have the following:

- Terraform installed on your local machine
- AWS account and project set up


## Usage
```hcl
module "provision" {
  source = "terraform-mirantis-modules/provision-aws/mirantis"

  name        = var.name
  common_tags = local.tags

  // network information
  network = var.network
  subnets = var.subnets

  // pass in a mix of nodegroups with the platform information
  nodegroups = { for k, ngd in local.nodegroups_wplatform : k => {
    ami : ngd.ami
    count : ngd.count
    type : ngd.type
    keypair_id : module.key.keypair_id
    root_device_name : ngd.root_device_name
    volume_size : ngd.volume_size
    role : ngd.role
    public : ngd.public
    user_data : ngd.user_data
  } }

  ingresses = local.launchpad_ingresses # see launchpad.tf

  securitygroups = local.launchpad_securitygroups # see launchpad.tf
}
```

## Root volume encryption

Nodegroup root volumes are EBS-encrypted by default (`volume_encrypted =
true`). With `volume_kms_key_id` left null, EC2 encrypts with the account's
default EBS key for the region (`aws/ebs`, or the customer-managed default
set through `ModifyEbsDefaultKmsKeyId`); no KMS configuration is required.

Setting `volume_kms_key_id` to a customer-managed key requires that key's
policy to allow `kms:CreateGrant` (and `kms:Decrypt`,
`kms:GenerateDataKeyWithoutPlaintext`) for `AWSServiceRoleForAutoScaling`.
Without it, instances fail to launch with `Client.InternalError`, which
appears as an ASG scaling activity failure rather than a terraform error.

`volume_kms_key_id` with `volume_encrypted = false` is rejected by a
variable validation: EC2 ignores the key in that combination, which would
otherwise silently produce an unencrypted volume.

## Ingress target registration

Each ingress creates one network load balancer and one target group per
route, then attaches the autoscaling group of every nodegroup listed in
its `nodegroups` to each of those target groups. The group registers its
own instances on the target group's port (`port_target`) and deregisters
them on scale-in, so target membership follows the nodegroup without a
terraform run.

This is the same model the sibling modules use: the azure module hands
`lb_pool_ids` to its scale sets, and the gcp module hands
`target_instance_groups` and `target_pools` to its ingress. None of the
three addresses individual instances, because a group handle is known
when terraform plans and an instance id is not.

Attachments are addressed `"<route>:<nodegroup>"`, both parts taken from
configuration, so scaling a nodegroup produces no attachment diff.

### Upgrading from 0.2.0 - 0.2.2

Those releases attached instances individually, keyed by instance id.
Instance ids come from `data.aws_instance.node`, which sits behind the
autoscaling groups, so on a fresh stack they are unknown when terraform
plans and the configuration was rejected:

```
Error: Invalid for_each argument
  local.target_instances will be known only after apply
```

Any stack configuring `ingresses` therefore could not be created on
0.2.0 - 0.2.2.

A stack applied on 0.1.x plans a one-time destroy of
`aws_lb_target_group_attachment.target_instances` and a create of
`aws_autoscaling_attachment.nodegroups`. The load balancer, its listeners
and its target groups are untouched; each node is briefly deregistered
and re-registered. There is no state move between the two: they are
different resource types.

## Examples
If you want to see a full example, check the [mke3 example](./examples/mke3).

## License

This project is licensed under the [MIT License].
