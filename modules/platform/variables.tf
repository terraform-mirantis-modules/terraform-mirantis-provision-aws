
variable "platform_key" {
  description = "Platform name/label key for the platforms list, which must match the internal library of platforms."
  type        = string
}

variable "windows_password" {
  description = "Password to use with windows & winrm, which is used to generate the windows user_data."
  type        = string
  sensitive   = true
  default     = ""
}


variable "extra_platforms" {
  description = "Additional platform definitions merged with the built-in library. Caller-supplied keys override built-ins on collision."
  type = map(object({
    ami_name       = string
    owner          = string
    interface      = string
    connection     = string
    ssh_user       = optional(string)
    ssh_port       = optional(number)
    winrm_user     = optional(string)
    winrm_useHTTPS = optional(bool)
    winrm_insecure = optional(bool)
  }))
  default = {}
}