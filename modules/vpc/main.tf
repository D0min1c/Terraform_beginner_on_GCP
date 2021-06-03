resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode            = var.routing_mode
  depends_on              = [ var.depends_on_list ]
}

resource "google_compute_subnetwork" "subnet" {
  for_each                 = { for s in var.subnets : "${s.subnet_name}" => s }
  name                     = each.value.subnet_name
  ip_cidr_range            = each.value.subnet_ip
  region                   = each.value.subnet_region
  network                  = google_compute_network.vpc.name
  private_ip_google_access = "false"
  log_config {
    aggregation_interval   = "INTERVAL_10_MIN"
    flow_sampling          = 0.5
    metadata               = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "allow_rules" {
  for_each                = var.firewall_allow
  network                 = google_compute_network.vpc.name
  name                    = each.key
  direction               = each.value.direction
  source_ranges           = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges      = each.value.direction == "EGRESS" ? each.value.ranges : null
  source_tags             = each.value.use_service_accounts || each.value.direction == "EGRESS" ? null : each.value.sources
  source_service_accounts = each.value.use_service_accounts && each.value.direction == "INGRESS" ? each.value.sources : null
  target_tags             = each.value.use_service_accounts ? null : each.value.targets
  target_service_accounts = each.value.use_service_accounts ? each.value.targets : null
  priority                = each.value.priority
# enable_logging          = each.value.enable_logging

  dynamic "allow" {
    for_each = [for rule in each.value.rules : rule if each.value.action == "allow"]
    iterator = rule
    content {
      protocol = rule.value.protocol
      ports    = rule.value.ports
    }
  }
}

resource "google_compute_firewall" "deny_rules" {
  for_each                = var.firewall_deny
  network                 = google_compute_network.vpc.name
  name                    = each.key
  direction               = each.value.direction
  source_ranges           = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges      = each.value.direction == "EGRESS" ? each.value.ranges : null
  source_tags             = each.value.use_service_accounts || each.value.direction == "EGRESS" ? null : each.value.sources
  source_service_accounts = each.value.use_service_accounts && each.value.direction == "INGRESS" ? each.value.sources : null
  target_tags             = each.value.use_service_accounts ? null : each.value.targets
  target_service_accounts = each.value.use_service_accounts ? each.value.targets : null
  priority                = each.value.priority

  dynamic "deny" {
    for_each = [for rule in each.value.rules : rule if each.value.action == "deny"]
    iterator = rule
    content {
      protocol = rule.value.protocol
      ports    = rule.value.ports
    }
  }
}