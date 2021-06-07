locals { 
  instances = flatten([ 
    for ins_key, ins in var.instance : [ 
      for disk_key, disk in ins.additional_disks : { 
        ins_key  = ins_key 
        disk_key = disk_key 
        network  = ins.network 
        image    = disk.source_image 
        size     = disk.disk_size_gb 
        type     = disk.type 
      } 
    ] 
  ]) 
} 
 
resource "google_compute_instance_from_template" "compute_instance" { 
  for_each         = var.instance 
  name             = each.key 
#  hostname         = "${each.key}.defalut.com" 
  zone             = format("%s-%s", element(split("/", each.value.network[0]), 3), each.value.network[1]) 
  tags             = each.value.network_tags 
  machine_type     = each.value.machine_type.0 == "N1" ? "custom-${each.value.machine_type.1}-${each.value.machine_type.2*1024}-ext" :  each.value.machine_type.0 == "N2" && each.value.machine_type.1 == each.value.machine_type.2 ? "n2-highcpu-${each.value.machine_type.1}" : each.value.machine_type.0 == "N2" ? "n2-custom-${each.value.machine_type.1}-${each.value.machine_type.2*1024}-ext" :  each.value.machine_type.0
  min_cpu_platform = each.value.machine_type.0 == "N1" ? "Intel Skylake" : "Intel Cascade Lake" 
 
  network_interface { 
    network       = each.value.network[2] 
    subnetwork    = element(split("/", each.value.network[0]), 5) 
    network_ip    = each.value.ipaddress[0] 
 
    access_config { 
      nat_ip = each.value.ipaddress[1] == "null" ? google_compute_address.external[each.key].address : data.google_compute_address.external[each.key].address 
    } 
  } 
 
  dynamic "boot_disk" { 
    for_each = each.value.boot_disk == null ? [] : each.value.boot_disk 
    iterator = disk 
    content { 
      auto_delete = "true" 
      initialize_params { 
        size  = lookup(disk.value, "disk_size_gb", null) 
        image = lookup(disk.value, "source_image", null) 
        type  = lookup(disk.value, "type", null) 
      } 
    } 
  } 
 
  labels = { 
    tag = each.value.instance_labels["tag"] == "null" ? null : each.value.instance_labels["tag"] 
  } 
 
  lifecycle { 
    ignore_changes = [attached_disk] 
  } 
 
  allow_stopping_for_update = "true" 
  deletion_protection       = "true" 
  depends_on                        = [ var.depends_on_list ] 
  source_instance_template  = each.value.instance_template 
}

data "google_compute_address" "external" {
  for_each = { for k, v in var.instance: k => v if v.ipaddress[1] != "null" }
  name     = each.value.ipaddress[1]
  region   = element(split("/",each.value.network[0]), 3)
}

resource "google_compute_address" "external" {
  for_each     = { for k, v in var.instance: k => v if v.ipaddress[1] == "null" }
  name         = each.key
  region       = element(split("/",each.value.network[0]), 3)
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}

resource "google_compute_disk" "additional" {
  for_each = {
    for i in local.instances: "${i.ins_key}-${i.disk_key+1}" => i if i.size != 0
  }
  name  = "${each.value.ins_key}-${each.value.disk_key+1}"
  zone  = format("%s-%s", element(split("/", each.value.network[0]), 3), each.value.network[1])
  image = each.value.image
  size  = each.value.size
  type  = each.value.type
}

resource "google_compute_attached_disk" "disk1" {
  for_each = {
    for i in local.instances: "${i.ins_key}-${i.disk_key+1}" => i if i.disk_key == 0 && i.size != 0
  }
  disk        = google_compute_disk.additional["${each.value.ins_key}-${each.value.disk_key+1}"].self_link
  instance    = google_compute_instance_from_template.compute_instance[each.value.ins_key].self_link
  device_name = "persistent-disk-${each.value.disk_key+1}"
}

resource "google_compute_attached_disk" "disk2" {
  for_each = {
    for i in local.instances: "${i.ins_key}-${i.disk_key+1}" => i if i.disk_key == 1 && i.size != 0
  }
  disk        = google_compute_disk.additional["${each.value.ins_key}-${each.value.disk_key+1}"].self_link
  instance    = google_compute_instance_from_template.compute_instance[each.value.ins_key].self_link
  device_name = "persistent-disk-${each.value.disk_key+1}"
  depends_on  = [ google_compute_attached_disk.disk1 ]
}

resource "google_compute_attached_disk" "disk3" {
  for_each = {
    for i in local.instances: "${i.ins_key}-${i.disk_key+1}" => i if i.disk_key == 2 && i.size != 0
  }
  disk        = google_compute_disk.additional["${each.value.ins_key}-${each.value.disk_key+1}"].self_link
  instance    = google_compute_instance_from_template.compute_instance[each.value.ins_key].self_link
  device_name = "persistent-disk-${each.value.disk_key+1}"
  depends_on  = [ google_compute_attached_disk.disk2 ]
}

