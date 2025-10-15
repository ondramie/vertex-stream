variable "project_id" {
  description = "The Google Cloud project ID (must be globally unique)"
  type        = string
}

variable "project_name" {
  description = "The Google Cloud project display name"
  type        = string
  default     = "Vertex AI Vision Stream"
}

variable "billing_account" {
  description = "The Google Cloud billing account ID"
  type        = string
}

variable "region" {
  description = "The Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The Google Cloud zone"
  type        = string
  default     = "us-central1-a"
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "vertex-stream"
}

variable "container_image" {
  description = "Container image for the application"
  type        = string
  default     = "gcr.io/cloudrun/hello"
}
