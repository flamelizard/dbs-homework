provider "google" {
  project = "bob-lab-320120"
  region  = "europe-central2"
  zone    = "europe-central2-a"
}

module "simpleAppDeployer" {
  source      = "./modules/terraform-gcp-simpleAppDeployer"
  region      = "europe-central2"
  zone        = "europe-central2-a"
  env         = var.env
  nodes_size  = var.nodes_size
  app_name    = var.app_name
  app_image   = var.app_image
  app_version = var.app_version
}

output "app_ip_address" {
  value = module.simpleAppDeployer.app_ip_address
}
