# k0s example

Provisions a k0s-shaped stack - controllers and workers behind one
load balancer on 6443 - and renders a `k0sctl.yaml` ready for
`k0sctl apply`.

Compared with the other examples in this repository:

- [`../mke3`](../mke3) builds an MKE 3 cluster and renders `launchpad.yaml`
- [`../windows`](../windows) covers the Windows/WinRM path

This example is Linux-only. It uses one security group per concern
(`cluster-internal`, `ssh`, `k0s-controller`) rather than a single
permissive group, so the rules a k0s control plane needs are explicit.

## Prerequisites

- Terraform
- AWS credentials in the environment (`AWS_PROFILE`, or the standard
  `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY` pair)
- `k0sctl` on `$PATH` to install the cluster afterwards

## Running it

```bash
cp terraform.tfvars.example terraform.tfvars
# edit: name (must be unique per stack), aws.region, k0sctl.k0s_version,
#       node counts and instance types

terraform init
terraform apply
```

Install k0s onto the provisioned machines:

```bash
terraform output -raw k0sctl_yaml > k0sctl.yaml
k0sctl apply --config k0sctl.yaml
```

The API endpoint the config points at:

```bash
terraform output -json k0s_connect
```

Tear it down when finished:

```bash
terraform destroy
```

## Inputs

| Variable | Description | Default |
|---|---|---|
| `name` | Stack name, used to label every resource | — |
| `aws.region` | AWS region | — |
| `network` | VPC CIDR and gateway flags | `172.31.0.0/16`, no NAT/VPN |
| `subnets` | Subnet CIDRs mapped to nodegroups | — |
| `nodegroups` | Machine group definitions (platform, type, count, role) | `{}` |
| `k0sctl.k0s_version` | k0s version written into the rendered config | — |
| `ssh_pk_location` | Directory for the generated SSH private key | `./ssh-keys/` |
| `extra_tags` | Tags applied to every resource | `{}` |

Nodegroups with `role = "controller"` are attached to the ingress and
become the k0s controllers; everything else is installed as a worker.

## Outputs

| Output | Description |
|---|---|
| `k0sctl_yaml` | Rendered k0sctl cluster config (sensitive) |
| `k0s_connect` | API URL for the cluster (sensitive) |
| `nodes` | Provisioned node details per group (sensitive) |
| `ingresses` | Load balancer DNS names |
| `platforms` | Resolved AMI data per platform (sensitive) |
