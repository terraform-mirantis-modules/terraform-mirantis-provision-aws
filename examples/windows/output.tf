output "nodes" {
  description = "Nodegroups with their node lists and connection metadata"
  value       = local.nodegroups
  sensitive   = true
}

output "ingresses" {
  description = "Ingresses with dns information"
  value       = local.ingresses
}

// The point of this example: everything needed to open a WinRM session
// against each windows node, in one place. Sensitive because it carries the
// administrator password.
output "winrm_connections" {
  description = "WinRM connection details per windows node. Read with: terraform output -json winrm_connections"
  sensitive   = true
  value = merge([for k, ng in local.nodegroups : {
    for n in ng.nodes : n.id => {
      address  = n.public_ip
      user     = ng.winrm_user
      password = local.windows_password
      useHTTPS = ng.winrm_useHTTPS
      insecure = ng.winrm_insecure
      port     = ng.winrm_useHTTPS ? 5986 : 5985
    }
  } if ng.connection == "winrm"]...)
}

// Sensitive because the platform module's output is sensitive as a whole (it
// can carry the windows password), and ssh_user is read from it. Read with:
// terraform output -json ssh_connections
output "ssh_connections" {
  description = "SSH connection details per linux node"
  sensitive   = true
  value = merge([for k, ng in local.nodegroups : {
    for n in ng.nodes : n.id => {
      address = n.public_ip
      user    = ng.ssh_user
      port    = ng.ssh_port
      keyPath = abspath(local_sensitive_file.ssh_private_key.filename)
    }
  } if ng.connection != "winrm"]...)
}
