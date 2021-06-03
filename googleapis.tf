resource "google_project_service" "googleapis" {

  for_each = toset([
"iam.googleapis.com",
"compute.googleapis.com",
"cloudresourcemanager.googleapis.com",
"stackdriver.googleapis.com",
"monitoring.googleapis.com",
])

  service = each.key
  disable_on_destroy = false        #
  disable_dependent_services = true #지정된 서비스 이외의 종속된 서비스 중지에 대한 설정
}
