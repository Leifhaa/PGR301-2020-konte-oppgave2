resource "google_storage_bucket" "gcp_bucket" {
  project = decisive-mapper-306016
  name = var.bucket_name
  location = "EU"
}