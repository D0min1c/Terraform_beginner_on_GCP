module "vpc" {
  source          = "./modules/vpc"
  network_name    = var.network_name
  depends_on_list = [ google_project_service.googleapis ]

# subnet add, modify
  subnets = [
    {
      subnet_name   = var.subnet_seoul["name"]
      subnet_ip     = var.subnet_seoul["cidr"]
      subnet_region = var.subnet_seoul["region"]
    },
  ]

##### allow rule #####
  firewall_allow = {
##### inbound #####
    admin = {
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["220.70.82.61/32"]
      sources              = null
      targets              = null
      use_service_accounts = false
      priority             = "1000"
      rules = [
        {
          protocol = "tcp"
          ports    = [ "22", "80", "443" ]
        }
      ]
    }
    internal-seoul = {
      direction            = "INGRESS"
      action               = "allow"
      ranges               = [var.subnet_seoul["cidr"]] # change
      sources              = null
      targets              = ["internal-seoul"]
      use_service_accounts = false
      priority             = "65534"
      rules = [
        {
          protocol = "tcp"
          ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
        },
        {
          protocol = "icmp"
          ports    = null
        }
      ]
    }
##### outbound #####
#    outbound = {
#      direction            = "EGRESS"
#      action               = "allow"
#      ranges               = ["0.0.0.0/0"]
#      sources              = null
#      targets              = null
#      use_service_accounts = false
#      priority             = "1000"
#      rules = [
#        {
#          protocol = "tcp"
#          ports    = ["0-65535"]
#        },
#        {
#          protocol = "udp"
#          ports    = ["0-65535"]
#        },
#        {
#          protocol = "icmp"
#          ports    = null
#        }
#      ]
#    }
######################################################################

  }

##### deny rule #####
  firewall_deny = {
##### outbound #####
    outbound-deny = {
      direction            = "EGRESS"
      action               = "deny"
      ranges               = ["0.0.0.0/0"]
      sources              = null
      targets              = null
      use_service_accounts = false
      priority             = "65534"
      rules = [
        {
          protocol = "tcp"
          ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
        }
      ]
    }
  }
}


