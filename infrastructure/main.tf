resource "google_project" "vertex_stream" {
  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account

  auto_create_network = true
}

resource "google_project_service" "vision_ai" {
  project = google_project.vertex_stream.project_id
  service = "visionai.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  project = google_project.vertex_stream.project_id
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "storage" {
  project = google_project.vertex_stream.project_id
  service = "storage.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "bigquery" {
  project = google_project.vertex_stream.project_id
  service = "bigquery.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "cloud_run" {
  project = google_project.vertex_stream.project_id
  service = "run.googleapis.com"

  disable_on_destroy = false
}

resource "google_project_service" "billing_budgets" {
  project = google_project.vertex_stream.project_id
  service = "billingbudgets.googleapis.com"

  disable_on_destroy = false
}

resource "google_service_account" "vertex_ai_admin" {
  project      = google_project.vertex_stream.project_id
  account_id   = "vertex-ai-admin"
  display_name = "Vertex AI Admin"

  depends_on = [google_project_service.compute]
}

resource "google_project_iam_member" "vision_ai_admin" {
  project = google_project.vertex_stream.project_id
  role    = "roles/visionai.admin"
  member  = "serviceAccount:${google_service_account.vertex_ai_admin.email}"
}

resource "google_project_iam_member" "storage_admin" {
  project = google_project.vertex_stream.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.vertex_ai_admin.email}"
}

resource "google_billing_budget" "budget" {
  billing_account = var.billing_account
  display_name    = "Vertex AI Vision Budget Alert"

  budget_filter {
    projects = ["projects/${google_project.vertex_stream.number}"]
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = "20"
    }
  }

  threshold_rules {
    threshold_percent = 0.25
  }

  threshold_rules {
    threshold_percent = 0.5
  }

  threshold_rules {
    threshold_percent = 0.75
  }

  threshold_rules {
    threshold_percent = 1.0
  }

  threshold_rules {
    threshold_percent = 1.5
    spend_basis       = "FORECASTED_SPEND"
  }

  depends_on = [google_project_service.billing_budgets]
}

# Note: Cloud Run service commented out until we have Vertex AI Vision streams set up
# Will add in next phase

# # Google Cloud Run service for vertex-stream
# resource "google_cloud_run_service" "vertex_stream" {
#   name     = var.service_name
#   location = var.region
#   project  = google_project.vertex_stream.project_id
#
#   template {
#     spec {
#       containers {
#         image = var.container_image
#
#         ports {
#           container_port = 8080
#         }
#
#         env {
#           name  = "PORT"
#           value = "8080"
#         }
#       }
#     }
#   }
#
#   traffic {
#     percent         = 100
#     latest_revision = true
#   }
#
#   depends_on = [google_project_service.cloud_run]
# }
#
# # IAM policy to allow unauthenticated access
# resource "google_cloud_run_service_iam_member" "public" {
#   service  = google_cloud_run_service.vertex_stream.name
#   location = google_cloud_run_service.vertex_stream.location
#   role     = "roles/run.invoker"
#   member   = "allUsers"
# }
