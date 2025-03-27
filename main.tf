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
  zone        = "asia-south1-a"
}

resource "google_compute_instance_template" "management_template" {
  name         = "management-template"
  machine_type = "e2-micro"

  disk {
    auto_delete  = true
    boot         = true
    source_image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
  }

  network_interface {
    network = "default"
    access_config {}
  }
}


resource "google_compute_firewall" "wordpress_ingress" {
  name    = "allow-ssh-http-https"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

