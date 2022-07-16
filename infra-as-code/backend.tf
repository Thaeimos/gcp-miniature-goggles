terraform {
  backend "gcs" {
    # bucket  = "BUCKET_NAME"
    bucket  = "bucket-tf-muscia-test-c3e4e07d"
    prefix  = "terraform/state"
  }
}