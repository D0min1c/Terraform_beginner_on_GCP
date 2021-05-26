provider "google" {
# version     = "= 3.32"
  credentials = file(var.credentials)
  project     = var.project["id"]
}