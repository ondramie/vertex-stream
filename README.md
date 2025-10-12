# vertex-stream

A boilerplate repository with Go backend and Terraform infrastructure for Google Cloud Platform.

## Project Structure

```
vertex-stream/
├── main.go                              # Main Go application
├── go.mod                               # Go module file
├── Dockerfile                           # Docker configuration
├── infrastructure/                      # Terraform infrastructure
│   ├── main.tf                         # Main Terraform configuration
│   ├── variables.tf                    # Terraform variables
│   ├── outputs.tf                      # Terraform outputs
│   └── terraform.tfvars.example        # Example variables file
└── README.md                           # This file
```

## Prerequisites

- [Go](https://golang.org/doc/install) (version 1.21 or later)
- [Terraform](https://www.terraform.io/downloads.html) (version 1.0 or later)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- Docker (optional, for containerization)

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/ondramie/vertex-stream.git
cd vertex-stream
```

### 2. Run the Go application locally

```bash
go run main.go
```

The application will start on `http://localhost:8080`. You can test it with:

```bash
curl http://localhost:8080
curl http://localhost:8080/health
```

### 3. Build the Go application

```bash
go build -o vertex-stream
./vertex-stream
```

## Infrastructure Deployment

### 1. Setup Google Cloud

```bash
# Authenticate with Google Cloud
gcloud auth login

# Set your project ID
gcloud config set project YOUR_PROJECT_ID

# Enable required APIs
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
```

### 2. Configure Terraform

```bash
cd infrastructure

# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your project details
```

### 3. Deploy infrastructure

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the changes
terraform apply
```

### 4. Build and deploy the application

```bash
# Build and push the Docker image
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/vertex-stream

# Update the Terraform configuration with the new image
# Then apply the changes
terraform apply
```

## Docker

### Build locally

```bash
docker build -t vertex-stream .
docker run -p 8080:8080 vertex-stream
```

## API Endpoints

- `GET /` - Welcome message
- `GET /health` - Health check endpoint

## Development

### Running tests

```bash
go test ./...
```

### Code formatting

```bash
go fmt ./...
```

### Dependencies

```bash
# Add a new dependency
go get github.com/example/package

# Update dependencies
go mod tidy
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.