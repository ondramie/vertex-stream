.PHONY: build run test clean docker-build docker-run terraform-init terraform-plan terraform-apply terraform-destroy

# Go commands
build:
	go build -o vertex-stream main.go

run:
	go run main.go

test:
	go test ./...

fmt:
	go fmt ./...

clean:
	rm -f vertex-stream
	go clean

# Docker commands
docker-build:
	docker build -t vertex-stream .

docker-run:
	docker run -p 8080:8080 vertex-stream

# Terraform commands
terraform-init:
	cd infrastructure && terraform init

terraform-plan:
	cd infrastructure && terraform plan

terraform-apply:
	cd infrastructure && terraform apply

terraform-destroy:
	cd infrastructure && terraform destroy

# Combined commands
dev: fmt test run

deploy: docker-build terraform-apply