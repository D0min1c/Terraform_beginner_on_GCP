variable "network_name" {
  type        = string
}
variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
}
variable "auto_create_subnetworks" {
  type        = bool
  default     = false
}
variable "subnets" {
  type = list(object({
    subnet_name   = string
    subnet_ip     = string
    subnet_region = string
  }))
  default = []
}
variable "firewall_allow" {
  type = map(object({
    direction            = string
    action               = string
    ranges               = list(string)
    sources              = list(string)
    targets              = list(string)
    priority             = string
    use_service_accounts = bool
    enable_logging       = bool
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
  }))
  default = {}
}
variable "firewall_deny" {
  type = map(object({
    direction            = string
    action               = string
    ranges               = list(string)
    sources              = list(string)
    targets              = list(string)
    priority             = string
    use_service_accounts = bool
    enable_logging       = bool
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
  }))
  default = {}
}
variable "depends_on_list" {
  default = []
}
