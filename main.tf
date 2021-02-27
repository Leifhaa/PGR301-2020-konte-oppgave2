#Create a service account
resource "google_service_account" "compute-service-account" {
  account_id   = "compute-account"
  display_name = "Service account for cloud compute"
}

resource "google_compute_instance" "gcp-compute-instance" {
  name         = "hello-konte"
  machine_type = var.machine_type
  zone         = "us-central1-c"

  tags = ["hello", "konte"]

  boot_disk {
    initialize_params {
      #Install debian on the compute instance
      image = "debian-cloud/debian-9"
    }
  }

  #Allows terraform to stop the instance, so we can e.g switch to another compute type.
  allow_stopping_for_update = true

  network_interface {
    #Name of the network which the server should be connected to
    #The Vm instance will use our created network instead of default one.
    network =  google_compute_network.vpc_network.self_link

    access_config {
      // Empty - means the address will be automatically assigned.
    }
  }

  service_account {
    # Set the created service account
    email  = google_service_account.compute-service-account.email
    #Google recommends the service account to have cloud-platform scope
    scopes = ["cloud-platform"]
  }


}

#Create a network resource with a subnetwork in each region
resource "google_compute_network" "vpc_network" {
  name = "hello-konte-network"
  auto_create_subnetworks = true
}
