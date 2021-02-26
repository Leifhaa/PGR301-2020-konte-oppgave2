resource "google_compute_instance" "gcp-compute-instance" {
  name         = "hello-konte"
  machine_type = "e2-micro"
  zone         = "us-central1-c"

  tags = ["hello", "konte"]

  boot_disk {
    initialize_params {
      #Install debian on the compute instance
      image = "debian-cloud/debian-9"
    }
  }


  network_interface {
    #Name of the network which the server should be connected to
    network = "default"

    access_config {
      // Empty - means the address will be automatically assigned.
    }
  }


}
