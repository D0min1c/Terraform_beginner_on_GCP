variable "instance" {
  type = map(object({
    instance_template = string
    network_tags      = list(string)
    network           = list(string)
    ipaddress         = list(string)
    machine_type      = list(string)
    instance_labels   = object({
      tag             = string
    })
    boot_disk         = list(object({
      source_image    = string
      disk_size_gb    = number
      type            = string
    }))
    additional_disks  = list(object({
      source_image    = string
      disk_size_gb    = number
      type            = string
    }))
  }))
  default = {}
}
variable "depends_on_list" {
  default = []
}
