resource "google_compute_health_check" "basic" {
  name = "${var.app_name}-health-check"

  timeout_sec        = 5
  check_interval_sec = 5

  # simple check for open port
  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_backend_service" "backend" {
  name                  = "${var.app_name}-backend"
  port_name             = "http"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.basic.self_link]

  backend {
    group          = google_compute_instance_group_manager.manager.instance_group
    balancing_mode = "UTILIZATION"
  }
}

resource "google_compute_url_map" "urlmap" {
  name            = "${var.app_name}-url-map"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "proxy" {
  name    = "${var.app_name}-http-proxy"
  url_map = google_compute_url_map.urlmap.id
}

resource "google_compute_global_forwarding_rule" "rule" {
  name                  = "${var.app_name}-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.proxy.id
}


