resource "google_storage_bucket" "gcp_bucket" {
  project = var.project_id
  name = var.bucket_name
  location = "EU"
}