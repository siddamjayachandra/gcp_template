terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  credentials = "credentials.json"
  project     = "eastern-adapter-455005-c6"
  region      = "asia-south1"
  zone        = "asia-south1-b"
}

resource "google_compute_instance_template" "management_template" {
  name         = "management-template"
  machine_type = "e2-micro"
  tags = ["ssh", "http-server"]
 
  disk {
    auto_delete  = true
    boot         = true
    source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
  }

  network_interface {
    network = "default"
    access_config {}
  }
  
}


resource "google_compute_firewall" "ingress" {
  name    = "my-ports"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh", "http-server"]
}
resource "google_compute_instance_from_template" "vm_from_template" {
  name     = "management"
  zone     = "asia-south1-b"
  source_instance_template = google_compute_instance_template.management_template.id
}

