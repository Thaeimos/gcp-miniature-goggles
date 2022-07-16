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
  name = "${var.gcp_project}-data-ingestion-${lower(random_string.random.result)}"
  location      = var.gcp_region
  force_destroy = true
}