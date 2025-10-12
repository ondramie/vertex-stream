# Outputs for vertex-stream infrastructure

output "service_url" {
  description = "URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.vertex_stream.status[0].url
}

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_service.vertex_stream.name
}

output "service_location" {
  description = "Location of the Cloud Run service"
  value       = google_cloud_run_service.vertex_stream.location
}