.PHONY: build run test clean docker-build docker-run terraform-init terraform-plan terraform-apply terraform-destroy stream-start stream-stop stream-logs

build:
	go build -o vertex-stream main.go

run:
	go run main.go

test:
	go test ./...

fmt:
	go fmt ./...

tidy:
	go mod tidy

clean:
	rm -f vertex-stream
	go clean

docker-build:
	docker build -t vertex-webcam-stream .

docker-run:
	docker run --rm -it vertex-webcam-stream

terraform-init:
	cd infrastructure && terraform init

terraform-plan:
	cd infrastructure && terraform plan

terraform-apply:
	cd infrastructure && terraform apply

terraform-destroy:
	cd infrastructure && terraform destroy

stream-start:
	docker-compose up -d
	@echo "✅ MediaMTX started in Docker"
	@echo ""
	@echo "Now start webcam capture:"
	@echo "  make webcam-start"
	@echo ""
	@echo "View stream at:"
	@echo "  http://localhost:8888/webcam"

webcam-start:
	@echo "🎥 Starting webcam capture (runs on Mac, streams to Docker MediaMTX)..."
	@echo "Press Ctrl+C to stop"
	@echo ""
	RTSP_SERVER=localhost:8554 go run main.go

stream-stop:
	docker-compose down

stream-logs:
	docker-compose logs -f

stream-logs-webcam:
	docker logs -f vertex-webcam

stream-logs-mediamtx:
	docker logs -f vertex-mediamtx

stream-restart:
	docker-compose restart

stream-rebuild:
	docker-compose down
	docker-compose build --no-cache
	docker-compose up -d

stream-ps:
	docker ps --filter "name=vertex"

stream-inspect:
	@echo "=== Container Status ==="
	@docker ps --filter "name=vertex"
	@echo ""
	@echo "=== Network Connections (webcam) ==="
	@docker exec vertex-webcam netstat -tuln 2>/dev/null || docker exec vertex-webcam ss -tuln 2>/dev/null || echo "Network tools not available"
	@echo ""
	@echo "=== Processes (webcam) ==="
	@docker exec vertex-webcam ps aux
	@echo ""
	@echo "=== Recent Logs (webcam) ==="
	@docker logs --tail 20 vertex-webcam

dev: fmt test run

deploy: docker-build terraform-apply
