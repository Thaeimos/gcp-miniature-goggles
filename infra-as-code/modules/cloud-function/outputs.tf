output "function_url" {
  value = google_cloudfunctions_function.function.https_trigger_url
}

output "function_name" {
  value = google_cloudfunctions_function.function.name
}