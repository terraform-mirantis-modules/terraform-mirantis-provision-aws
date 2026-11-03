# Windows / WinRM example

Provisions a mixed stack - one Linux manager, one Windows worker - to
exercise the parts of the module that only Windows nodegroups reach:

- a `windows_*` platform key, which resolves a Windows AMI and sets
  `connection = "winrm"` plus `winrm_user`, `winrm_useHTTPS`,
  `winrm_insecure`
- the WinRM bootstrap `user_data` the platform module renders for winrm
  platforms (Administrator password reset, WinRM-over-HTTPS listener)
- a security group rule expressed as a port **range** (5985-5986), rather
  than the single ports the other examples use
- per-nodegroup security groups, so Linux nodes get SSH and Windows nodes
  get WinRM and RDP rather than one permissive group
- an ingress attached to **two** nodegroups, which fans the target group
  attachments out across both autoscaling groups

For a Linux-only launchpad stack use [`../mke3`](../mke3); for k0s use
[`../k0sctl`](../k0sctl).

## Running it

```bash
cp terraform.tfvars.example terraform.tfvars
# edit: name (must be unique per stack), aws.region, platforms, sizes

terraform init
terraform apply
```

Read the connection details out:

```bash
terraform output -raw  windows_password
terraform output -json winrm_connections
terraform output -json ssh_connections
```

`winrm_connections` gives address, user, password, port and the TLS flags
for each Windows node. Check the listener is up before trying to use it -
EC2Launch runs the user-data script after the instance reports running, so
WinRM answers a minute or two later than the apply returns:

```bash
ADDR=$(terraform output -json winrm_connections | jq -r 'to_entries[0].value.address')
# 5986 is WinRM over HTTPS with the self-signed certificate the bootstrap installs
openssl s_client -connect "$ADDR:5986" -brief </dev/null
```

Tear it down when finished:

```bash
terraform destroy
```

## Notes

The stack uses an RSA key pair, not ed25519: EC2 rejects an ed25519 key on a
Windows AMI when the launch template is validated, which surfaces as an
autoscaling group creation failure on apply rather than a plan error. One key
is shared by the whole stack, and Linux nodes accept RSA.


The Windows password is generated unless `windows_password` is set in
`terraform.tfvars`. Either way it is written into the instance's EC2
user-data, because that is how the WinRM listener gets configured. Anything
able to read the instance metadata service on that host can therefore read
it; treat these instances as disposable and do not reuse the password
elsewhere. This is also why `modules/platform` marks its whole output
sensitive, and why the outputs here that read from it are sensitive too.

The platform library carries `windows_2019`, `windows_2022` and
`windows_2025`, each with `_core_` and `_full_` variants. `terraform output
-json platforms` is not exposed here; use `../mke3` if you want to inspect
the resolved platform data.
