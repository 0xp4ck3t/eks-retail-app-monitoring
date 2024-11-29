# --- network/variables.tf --

variable "private_sn_count" {
  type = number
}

variable "public_sn_count" {
  type = number
}

variable "vpc_cidr" {
  type = string
}

variable "access_ip" {
  type = string
}

variable "https_security_groups" {}
variable "ssh_security_groups" {}
variable "alb_security_groups" {}
