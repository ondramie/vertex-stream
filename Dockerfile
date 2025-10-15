FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o webcam-stream .

FROM alpine:latest

RUN apk --no-cache add ffmpeg ca-certificates

WORKDIR /root/

COPY --from=builder /app/webcam-stream .

CMD ["./webcam-stream"]
