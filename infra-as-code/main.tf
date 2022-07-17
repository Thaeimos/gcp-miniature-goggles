# Random string for the bucket creation

resource "random_string" "random" {
  length  = 9
  special = false
  lower   = true
}

resource "google_storage_bucket" "bucket_data_retention" {
  name = "${var.gcp_project}-data-retention-${lower(random_string.random.result)}"
  location      = var.gcp_region
  force_destroy = true
}

# App Engine for data ingestion section
# We start the App Engine service and create a 'default' version to be used or not later on codes update

resource "google_storage_bucket" "bucket_data_ingestion" {
  name          = "${var.gcp_project}-data-ingestion-${lower(random_string.random.result)}"
  location      = var.gcp_region
  force_destroy = true
}

module "cloud-function" {
  source          = "./modules/cloud-function"
  project         = var.gcp_project
  gcp_region      = var.gcp_region
  function_name   = "production-app"
  entry_point     = "hello_world"
  function_folder = "./cloud-function-producer"
  runtime         = "python39"
}