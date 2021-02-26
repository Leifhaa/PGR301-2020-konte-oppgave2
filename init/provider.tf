terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

#A provider is used to configure the named provider. A provider is responsible for creating resources
#multiple provider blocks can exist if Terraform configuration manages resources from different providers
provider "google" {
  version = "3.5.0"
  credentials = file("terraform_keyfile.json")
  project     = var.project_id
  region  = "us-central1"
  zone    = "us-central1-c"
}