variable "boot_disk" {
  type = list(object({
    auto_delete  = bool
    boot         = bool
    disk_size_gb = number
    disk_type    = string
    source_image = string
  }))
  default = []
}
variable "additional_disks" {
  type = list(object({
    auto_delete  = bool
    boot         = bool
    disk_size_gb = number
    disk_type    = string
    source_image = string
  }))
  default = []
}
variable "access_config" {
  type = list(object({
    nat_ip       = string
    network_tier = string
  }))
  default = []
}
variable "service_account" {
  type = object({
    email  = string
    scopes = set(string)
  })
}
variable "metadata" {
  type = map(string)
}
variable "template_name" {
  type = string
}
variable "machine_type" {
  type = string
}
#variable "network_tags" {
#  type = list(string)
#  default = []
#}
variable "template_region" {
  type = string
}
variable "template_subnet" {
  type = string
}
variable "depends_on_list" {
  default = []
}
