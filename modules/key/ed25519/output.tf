
output "keypair_id" {
  description = "AWS EC2 key-pair id"
  value       = aws_key_pair.keypair.id
}

output "private_key" {
  description = "Private key contents"
  value       = tls_private_key.ed25519.private_key_openssh
}


output "public_key" {
  description = "Public key in OpenSSH format"
  value       = tls_private_key.ed25519.public_key_openssh
}