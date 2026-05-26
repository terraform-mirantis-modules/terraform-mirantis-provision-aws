# Example: MKE 3 cluster on AWS

Provisions a complete Mirantis Kubernetes Engine 3.x cluster on AWS using this module, then assembles a ready-to-use `launchpad.yaml` for MCR + MKE (+ optional MSR) installation.

## What it does

1. **Resolves AMIs** — the `platform` sub-module looks up the correct AMI for each declared OS platform (e.g. `rhel_9.3`, `ubuntu_22.04`) so you never hard-code image IDs.
2. **Provisions infrastructure** — creates a VPC, subnets, security groups, an MKE load balancer, SSH key pair, and EC2 instances grouped by role (`manager`, `worker`, `msr`).
3. **Produces a Launchpad config** — after provisioning, constructs a `launchpad.yaml` (MKE v1.4 format) from the live node IPs and load-balancer DNS. Feed this directly to `launchpad apply` to install the cluster.

## Prerequisites

- Terraform >= 1.0
- AWS credentials configured (`AWS_PROFILE` or `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`)
- `launchpad` CLI for the install step

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars — set name, mke_connect credentials, node counts/types
terraform init
terraform apply
# retrieve the generated launchpad config
terraform output -raw launchpad_yaml > launchpad.yaml
launchpad apply -c launchpad.yaml
```

## Inputs

| Variable | Description | Default |
|---|---|---|
| `name` | Stack/cluster name, used in all resource labels | — |
| `aws.region` | AWS region | `us-east-1` |
| `network` | VPC CIDR and gateway flags | `172.31.0.0/16`, no NAT/VPN |
| `subnets` | Subnet CIDR blocks mapped to node groups | `{}` |
| `nodegroups` | EC2 node group definitions (platform, type, count, role) | — |
| `mke` | MCR/MKE/MSR versions and MKE admin credentials | — |
| `ssh_pk_location` | Directory to write the generated SSH private key | `./ssh-keys/` |
| `windows_password` | WinRM password, required if any Windows workers are declared | `""` |
| `extra_tags` | Additional AWS tags applied to all resources | `{}` |

## Outputs

| Output | Description |
|---|---|
| `launchpad_yaml` | Rendered `launchpad.yaml` ready for `launchpad apply` (sensitive) |
| `mke_connect` | MKE endpoint, username, password (sensitive) |
| `nodes` | Provisioned node details per group (sensitive) |
| `ingresses` | Load-balancer DNS names |
| `platforms` | Resolved AMI data per platform (sensitive) |

## Example topology (`terraform.tfvars.example`)

The bundled example creates a minimal two-node cluster:

| Group | Role | OS | Instance type | Count |
|---|---|---|---|---|
| `AMngr` | manager | RHEL 9.3 | m6a.2xlarge | 1 |
| `AWrk_Ubu22` | worker | Ubuntu 22.04 | c6a.xlarge | 1 |

To add MSR, declare a node group with `role = "msr"` and set `launchpad.msr_version`.
