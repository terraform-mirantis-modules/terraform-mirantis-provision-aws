# Example: cluster provisioning with a known AMI

Provisions a cluster on AWS by selecting AMIs directly via Terraform data
sources, without using the `platform` sub-module.  Use this example when you
already know which OS image you want and do not need the built-in AMI library.

## Why this example exists

The root module is image-agnostic: it accepts any AMI ID and the corresponding
`root_device_name`, leaving image selection entirely to the caller.  The
`platform` sub-module is a convenience layer that resolves those values from a
built-in library of well-known OS images.

This example shows the path that bypasses that library.  It is appropriate when:

- you want to pin to a specific OS distribution or version that is not in the
  built-in library, or
- you want the most recent image published by a known owner without maintaining
  a name pattern inside the platform module.

The example uses **Rocky Linux 9** (published by the Rocky Enterprise Software
Foundation) as a concrete demonstration.

## How it works

### AMI selection (`ami.tf`)

A `data "aws_ami"` resource is declared once per node group using `for_each`.
Each entry filters by the `ami_name` glob and `ami_owner` supplied in
`var.nodegroups`, and `most_recent = true` ensures the latest matching image is
always resolved:

```hcl
data "aws_ami" "nodegroup" {
  for_each = var.nodegroups

  most_recent = true
  owners      = [each.value.ami_owner]

  filter {
    name   = "image-id"
    values = [each.value.ami_name]
  }
}
```

> For Rocky Linux 9 the owner is `792107900699` (RESF) and the name pattern is
> `Rocky-9-EC2-Base-9.*x86_64*`.  Substitute any owner/pattern combination for
> other distributions.

### Wiring into the root module (`provision.tf`)

The resolved AMI ID and `root_device_name` are passed directly to the root
module's `nodegroups` input — no intermediate module required:

```hcl
nodegroups = { for k, ng in var.nodegroups : k => {
  source_image = {
    ami = data.aws_ami.nodegroup[k].id
  }
  root_device_name = data.aws_ami.nodegroup[k].root_device_name
  ...
} }
```

`root_device_name` is derived automatically from the data source so you never
need to hard-code it (e.g. `/dev/sda1` vs `/dev/xvda`).

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: set name, region, instance types, and node counts
terraform init
terraform apply
```

SSH key material is written to `./ssh-keys/<name>-common.pem` (mode `0600`).

```bash
# connect to a node
ssh -i ./ssh-keys/<name>-common.pem rocky@<public-ip>
```

Retrieve node details (IPs, SSH key path, resolved AMIs) after apply:

```bash
terraform output -json nodes
terraform output -json amis
```

## Inputs

| Variable | Description | Default |
|---|---|---|
| `name` | Stack name used to label all resources | — |
| `aws.region` | AWS region | `us-east-1` |
| `network` | VPC CIDR and gateway flags | `172.31.0.0/16`, no NAT/VPN |
| `subnets` | Subnet CIDR blocks mapped to node group names | `{}` |
| `nodegroups` | Node group definitions — see shape below | — |
| `extra_tags` | Additional AWS tags applied to all resources | `{}` |
| `ssh_pk_location` | Directory to write the generated SSH private key | `./ssh-keys/` |

### `nodegroups` entry shape

| Field | Type | Description |
|---|---|---|
| `ami_name` | `string` | AMI name glob, e.g. `Rocky-9-EC2-Base-9.*x86_64*` |
| `ami_owner` | `string` | AWS account ID of the AMI publisher |
| `ssh_user` | `string` | Default SSH user for the image, e.g. `rocky` |
| `ssh_port` | `number` | SSH port (default `22`) |
| `type` | `string` | EC2 instance type |
| `count` | `number` | Number of instances in the group |
| `volume_size` | `number` | Root volume size in GiB |
| `role` | `string` | Logical role label, e.g. `manager`, `worker` |
| `public` | `bool` | Assign a public IP |
| `user_data` | `string` | Cloud-init user data (default `""`) |

## Outputs

| Output | Description |
|---|---|
| `nodes` | Provisioned node details per group, including IPs and SSH key path (sensitive) |
| `amis` | Resolved AMI ID, name, and `root_device_name` per node group |
| `ssh_private_key_path` | Absolute path to the generated SSH private key |

## Example topology (`terraform.tfvars.example`)

| Group | Role | AMI | Instance type | Count |
|---|---|---|---|---|
| `managers` | manager | Rocky Linux 9 (latest) | m6a.2xlarge | 1 |
| `workers` | worker | Rocky Linux 9 (latest) | c6a.xlarge | 2 |
