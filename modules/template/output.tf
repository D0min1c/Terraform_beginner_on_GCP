output "self_link" {
  value       = google_compute_instance_template.default.self_link
}
output "name" {
  value       = google_compute_instance_template.default.name
}
output "tags" {
  value       = google_compute_instance_template.default.tags
}