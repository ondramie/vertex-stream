# Main Terraform configuration for vertex-stream

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Configure the Google Cloud Provider
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Google Cloud Run service for vertex-stream
resource "google_cloud_run_service" "vertex_stream" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.container_image
        
        ports {
          container_port = 8080
        }
        
        env {
          name  = "PORT"
          value = "8080"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# IAM policy to allow unauthenticated access
resource "google_cloud_run_service_iam_member" "public" {
  service  = google_cloud_run_service.vertex_stream.name
  location = google_cloud_run_service.vertex_stream.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}