# Random string for the bucket creation
resource "random_string" "random" {
  length  = 9
  special = false
  lower   = true
}

# Consumer cloud function
module "cloud-function-producer" {
  source          = "./modules/cloud-function"
  project         = var.gcp_project
  gcp_region      = var.gcp_region
  function_name   = "production-app-producer"
  entry_point     = "hello_world"
  function_folder = "./cloud-function-producer"
  runtime         = "python39"
}

# Setup scheduler and permissions
resource "google_service_account" "service_account" {
  account_id   = "cloud-function-invoker"
  display_name = "Cloud Function Tutorial Invoker Service Account"
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = var.gcp_project
  region         = var.gcp_region
  cloud_function = module.cloud-function-producer.function_name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_cloud_scheduler_job" "hellow-world-job" {
  name         = "scheduler-data-ingestion"
  description  = "Trigger the ${module.cloud-function-producer.function_name} Cloud Function every 10 mins."
  schedule     = "0/2 * * * *"
  http_target {
    http_method = "GET"
    uri = module.cloud-function-producer.function_url
    oidc_token {
      service_account_email = google_service_account.service_account.email
    }
  }
}

# Second instance
module "cloud-function-consumer" {
  source          = "./modules/cloud-function"
  project         = var.gcp_project
  gcp_region      = var.gcp_region
  function_name   = "production-app-consumer"
  entry_point     = "hello_world"
  function_folder = "./cloud-function-producer"
  runtime         = "python39"
}