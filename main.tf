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
    network = "default"

    access_config {
      // Empty - means the address will be automatically assigned.
    }
  }


}
