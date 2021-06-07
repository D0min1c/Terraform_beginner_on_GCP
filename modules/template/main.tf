resource "google_compute_instance_template" "default" {
  name           = var.template_name
  region         = var.template_region
  machine_type   = var.machine_type
#  tags           = var.network_tags
  can_ip_forward = "false"
  metadata       = var.metadata
  depends_on     = [ var.depends_on_list ]

  dynamic "disk" {
    for_each = concat(var.boot_disk, var.additional_disks)
    content {
      auto_delete  = lookup(disk.value, "auto_delete", null)
      boot         = lookup(disk.value, "boot", null)
      device_name  = lookup(disk.value, "device_name", null)
      disk_name    = lookup(disk.value, "disk_name", null)
      disk_size_gb = lookup(disk.value, "disk_size_gb", null)
      disk_type    = lookup(disk.value, "disk_type", null)
      interface    = lookup(disk.value, "interface", null)
      mode         = lookup(disk.value, "mode", null)
      source       = lookup(disk.value, "source", null)
      source_image = lookup(disk.value, "source_image", null)
      type         = lookup(disk.value, "type", null)

    }
  }

  dynamic "service_account" {
    for_each = [var.service_account]
    content {
      email  = lookup(service_account.value, "email", null)
      scopes = lookup(service_account.value, "scopes", null)
    }
  }

  network_interface {
    subnetwork         = var.template_subnet
    dynamic "access_config" {
      for_each = var.access_config
      content {
        nat_ip       = access_config.value.nat_ip
        network_tier = access_config.value.network_tier
      }
    }
  }

#  lifecycle {
#    create_before_destroy = "true"
#  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

}