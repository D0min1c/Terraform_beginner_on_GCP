output "network" {
  value       = google_compute_network.vpc
}
output "network_name" {
  value       = google_compute_network.vpc.name
}
output "subnets" {
  value       = google_compute_subnetwork.subnet
}
output "self_link" {
  value       = google_compute_network.vpc.self_link
}