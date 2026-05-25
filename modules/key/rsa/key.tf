
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "keypair" {
  key_name   = var.name
  public_key = tls_private_key.rsa.public_key_openssh

  tags = merge({
    stack     = var.name
    algorythm = "RSA"
    role      = "sshkey"
  }, var.tags)
}
