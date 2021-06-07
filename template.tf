module "template_default" {
  source          = "./modules/template"
  template_name   = "template-default" # change
  template_region = "us-central1"
  template_subnet = "default"
  machine_type    = "g1-small"
  depends_on_list = [ google_project_service.googleapis ]

  service_account = {
    email  = "${var.project["number"]}-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  metadata = {
    ssh-keys = "${var.ssh["user"]}:${file(var.ssh["key"])}"
    block-project-ssh-keys = "true"
  }

  access_config = [
    {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
  ]

  boot_disk = [
    {
# ubuntu-os-cloud/ubuntu-1604-lts, centos-cloud/centos-7, debian-cloud/debian-9
      source_image = "ubuntu-os-cloud/ubuntu-1604-lts" # change
      disk_size_gb = 50 # change
      disk_type    = "pd-ssd"
      auto_delete  = "true"
      boot         = "true"
    }
  ]
}