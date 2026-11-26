variable "admin_cidr" {
  description = "Endereco IP autorizado para acesso SSH"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instancia EC2 da aplicacao"
  type        = string
  default     = "t3.small"

  validation {
    condition     = contains(["t3.small", "t3.medium"], var.instance_type)
    error_message = "Utilize t3.small ou t3.medium."
  }
}
