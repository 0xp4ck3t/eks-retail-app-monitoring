locals {
  vpc_cidr = "10.10.0.0/16"
}

locals {
  ssh_security_groups = {
    ssh_access = {
      name        = "ssh_SG"
      description = "SG for SSH Access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
  }
  https_security_groups = {
    http_access = {
      name        = "http_SG"
      description = "SG for HTTP Access"
      ingress = {
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
}

locals {
  ALB_security_groups = {
    ALB_SG = {
      name = "ALB_SG"
      description = "SG for ALB"
      ingress = {
        http = {
          from = 80
          to = 80
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        https = {
          from = 443
          to = 443
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
}