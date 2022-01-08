variable "machine_type" {
  type = string
  default = "e2-micro"
}

variable "fcos_stream" {
  type = string
  default = "next"
}

resource "google_compute_instance" "fcos_next" {
  name         = "fcos-next"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = "fedora-coreos-cloud/fedora-coreos-${var.fcos_stream}"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    user-data = "${file("../fcos-test-day.ign")}"
  }
}
