# COS image for simplicity
data "google_compute_image" "cos" {
  family  = "cos-stable"
  project = "cos-cloud"
}

resource "google_compute_instance_template" "template" {
  name_prefix  = "${var.app_name}-template"
  machine_type = "e2-medium"
  region       = var.region

  disk {
    source_image = data.google_compute_image.cos.self_link
  }

  network_interface {
    network = "default"
  }

  metadata = {
    startup-script = <<EOF
      #!/bin/bash
      set -xe
      docker run -d -p 80:80 ${var.app_image}:${var.app_version}
    EOF
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "manager" {
  name               = "${var.app_name}-igm"
  base_instance_name = var.app_name
  zone               = var.zone
  target_size        = var.nodes_size

  version {
    instance_template = google_compute_instance_template.template.self_link
  }

  named_port {
    name = "http"
    port = 80
  }
}

