resource "google_project_service" "googleapis" {

  for_each = toset([
"iam.googleapis.com",
"compute.googleapis.com",
"storage.googleapis.com",
"cloudresourcemanager.googleapis.com",
"stackdriver.googleapis.com",
"monitoring.googleapis.com",
"cloudscheduler.googleapis.com",
"cloudfunctions.googleapis.com",
"pubsub.googleapis.com",
])

  service = each.key
  disable_on_destroy = false
  disable_dependent_services = true
}
