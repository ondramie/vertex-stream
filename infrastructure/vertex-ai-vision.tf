resource "google_vertex_ai_stream" "webcam_stream" {
  project  = google_project.vertex_stream.project_id
  location = var.region
  name     = "webcam-facial-expression"

  depends_on = [google_project_service.vision_ai]
}

resource "google_vertex_ai_application" "face_detector" {
  project     = google_project.vertex_stream.project_id
  location    = var.region
  name        = "facial-expression-detector"
  description = "Real-time facial expression detection"

  runtime_config {
    input_stream = google_vertex_ai_stream.webcam_stream.name
  }

  graph {
    nodes {
      name      = "face_detector"
      processor = "face-detector"

      processor_config {
        face_detector {
          min_confidence = 0.5
        }
      }
    }

    nodes {
      name      = "output"
      processor = "stream-output"
    }
  }

  depends_on = [google_vertex_ai_stream.webcam_stream]
}
