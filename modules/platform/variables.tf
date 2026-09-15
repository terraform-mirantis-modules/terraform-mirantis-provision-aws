
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

variable "user_data" {
  description = "Optional caller-supplied user_data. For winrm platforms this is appended after the module's own required setup (Administrator password reset + WinRM-over-HTTPS listener, from userdata_windows.tpl) rather than replacing it, since that setup is a fixed prerequisite for WinRM connectivity, not just a convenience default. For non-winrm platforms it is used as the platform's user_data directly."
  type        = string
  default     = ""
}