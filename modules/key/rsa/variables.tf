variable "name" {
  description = "What label to use for the keypair"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources being generated"
  type        = map(string)
  default     = {}
}

variable "rsa_bits" {
  description = "When algorithm is RSA, the size of the generated RSA key in bits."
  type        = number
  default     = 4096
}
