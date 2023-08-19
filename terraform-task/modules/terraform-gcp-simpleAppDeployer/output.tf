output "app_ip_address" {
  value = google_compute_global_forwarding_rule.rule.ip_address
}
