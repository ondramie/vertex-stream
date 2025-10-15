output "project_id" {
  description = "The Google Cloud project ID"
  value       = google_project.vertex_stream.project_id
}

output "project_number" {
  description = "The Google Cloud project number"
  value       = google_project.vertex_stream.number
}

output "service_account_email" {
  description = "Email of the Vertex AI service account"
  value       = google_service_account.vertex_ai_admin.email
}

output "region" {
  description = "The Google Cloud region"
  value       = var.region
}
