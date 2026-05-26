
// Roles that k0sctl recognises as cluster members.
locals {
  k0sctl_roles = ["controller", "worker", "controller+worker"]
}

// === Ingress ===

locals {
  k0sctl_ingresses = {
    "k0s" = {
      description = "k0s API server load balancer"
      // Only controllers (and controller+worker nodes) sit behind this ALB.
      nodegroups = [for k, ng in var.nodegroups : k if contains(["controller", "controller+worker"], ng.role)]

      routes = {
        "api" = {
          port_incoming = 6443
          port_target   = 6443
          protocol      = "TCP"
        }
      }

      tags = {}
    }
  }
}

// === Security groups ===

locals {
  k0sctl_securitygroups = {

    // Unrestricted east-west traffic between all cluster members.
    // Required for: konnectivity (8132), etcd (2380), calico/flannel overlay,
    // kubelet (10250), and any other intra-cluster communication.
    "cluster-internal" = {
      description = "Unrestricted traffic between cluster members"
      nodegroups  = [for n, ng in var.nodegroups : n]
      ingress_ipv4 = [
        {
          description = "All intra-cluster traffic"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          self        = true
          cidr_blocks = []
        }
      ]
      egress_ipv4 = [
        {
          description = "All outbound traffic"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          self        = false
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      tags = {}
    }

    // SSH access for k0sctl to reach every node.
    "ssh" = {
      description = "SSH access for k0sctl and operators"
      nodegroups  = [for n, ng in var.nodegroups : n]
      ingress_ipv4 = [
        {
          description = "SSH"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          self        = false
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_ipv4 = []
      tags        = {}
    }

    // Kubernetes API and k0s controller join API — controllers only.
    // The ALB health checks and direct kubectl traffic both hit 6443.
    // Port 9443 is the k0s controller join API used when adding controllers.
    "k0s-controller" = {
      description = "k0s controller ports (API server, join API)"
      nodegroups  = [for n, ng in var.nodegroups : n if contains(["controller", "controller+worker"], ng.role)]
      ingress_ipv4 = [
        {
          description = "Kubernetes API server"
          from_port   = 6443
          to_port     = 6443
          protocol    = "tcp"
          self        = false
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "k0s controller join API"
          from_port   = 9443
          to_port     = 9443
          protocol    = "tcp"
          self        = false
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_ipv4 = []
      tags        = {}
    }

  }
}

// === Post-provision locals ===

locals {
  // DNS name of the ALB in front of controllers — used as the API SAN.
  k0s_api_url = module.provision.ingresses["k0s"].lb_dns

  // Flatten all cluster nodegroups into a per-node host map.
  k0sctl_hosts = merge([for k, ng in local.nodegroups : {
    for l, ngn in ng.nodes : ngn.label => {
      label    = ngn.label
      role     = ng.role
      address  = ngn.public_ip
      user     = ng.ssh_user
      port     = ng.ssh_port
      key_path = abspath(local_sensitive_file.ssh_private_key.filename)
    }
  } if contains(local.k0sctl_roles, ng.role)]...)
}

// === k0sctl cluster YAML ===

locals {
  k0sctl_yaml = <<-EOT
apiVersion: k0sctl.k0sproject.io/v1beta1
kind: Cluster
metadata:
  name: ${var.name}
spec:
  hosts:
%{~for h in local.k0sctl_hosts}
  - role: ${h.role}
    ssh:
      address: ${h.address}
      user: ${h.user}
      port: ${h.port}
      keyPath: ${h.key_path}
%{~endfor}
  k0s:
    version: ${var.k0sctl.k0s_version}
    config:
      apiVersion: k0s.k0sproject.io/v1beta1
      kind: ClusterConfig
      metadata:
        name: ${var.name}
      spec:
        api:
          externalAddress: ${local.k0s_api_url}
          sans:
          - ${local.k0s_api_url}
EOT
}

// === Outputs ===

output "k0sctl_yaml" {
  description = "k0sctl cluster config (pass to 'k0sctl apply --config -')"
  sensitive   = true
  value       = local.k0sctl_yaml
}

output "k0s_connect" {
  description = "Connection details for the provisioned cluster"
  sensitive   = true
  value = {
    api_url = "https://${local.k0s_api_url}:6443"
  }
}
