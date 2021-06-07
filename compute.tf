module "compute_instance" {
  source          = "./modules/compute"
  depends_on_list = [ module.vpc.subnets ]

  instance = {

# change hostname, template name, subnet name, az, ipaddress, network_tags, machine_type, disks
# modify hostname in module main.tf
###########
#Dev-seoul#
###########
   terraform-web-test-1 = {
      instance_template = module.template_default.self_link
      network           = [ "${module.vpc.subnets["${var.subnet_seoul["name"]}"].id}", "a", module.vpc.network_name ]
      ipaddress         = [ "172.20.10.11", "null" ]
      network_tags      = ["internal-seoul","admin"]
      instance_labels   = { tag = "null" }

      machine_type      = [ "N1", "1", "1" ]
      boot_disk         = [{ source_image = "centos-cloud/centos-7", disk_size_gb = 50, type = "pd-ssd" }]
      additional_disks  = []
   }
   terraform-web-test-2 = {
      instance_template = module.template_default.self_link
      network           = [ "${module.vpc.subnets["${var.subnet_seoul["name"]}"].id}", "a", module.vpc.network_name ]
      ipaddress         = [ "172.20.10.12", "null" ]
      network_tags      = ["internal-seoul","admin"]
      instance_labels   = { tag = "null" }

      machine_type      = [ "N1", "1", "1" ]
      boot_disk         = [{ source_image = "centos-cloud/centos-7", disk_size_gb = 50, type = "pd-ssd" }]
      additional_disks  = []
   }
#######


  }
}