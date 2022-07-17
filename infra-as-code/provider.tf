terraform {
  required_version = ">= 1.1.0, < 2.0.0"
}

provider "google" {
  credentials = file(var.gcp_auth_file)
  project     = var.gcp_project
  region      = var.gcp_region
}