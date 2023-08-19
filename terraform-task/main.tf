provider "google" {
  # todo read credentials
  project = "bob-lab-320120"
  zone    = "europe-central2-a"
  region  = "europe-central2"
}

module "simpleAppDeployer" {
  source      = "./modules/terraform-gcp-simpleAppDeployer"
  region      = "europe-central2"
  zone        = "europe-central2-a"
  env         = "staging"
  nodes_size  = 2
  app_name    = "hello-app"
  app_image   = "nginxdemos/hello"
  app_version = "0.3"
}

output "app_ip_address" {
  value = module.simpleAppDeployer.app_ip_address
}
