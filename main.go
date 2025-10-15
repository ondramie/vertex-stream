package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"syscall"
)

func main() {
	rtspServer := getEnv("RTSP_SERVER", "localhost:8554")
	streamName := getEnv("STREAM_NAME", "webcam")
	rtspURL := fmt.Sprintf("rtsp://%s/%s", rtspServer, streamName)

	log.Printf("Starting webcam capture...")
	log.Printf("Streaming to: %s", rtspURL)

	cmd := exec.Command("ffmpeg",
		"-f", "avfoundation",
		"-video_size", "1280x720",
		"-framerate", "30.0",
		"-i", "0",
		"-c:v", "libx264",
		"-preset", "ultrafast",
		"-tune", "zerolatency",
		"-b:v", "2M",
		"-maxrate", "2M",
		"-bufsize", "4M",
		"-pix_fmt", "yuv420p",
		"-g", "60",
		"-f", "rtsp",
		"-rtsp_transport", "tcp",
		rtspURL,
	)

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Start(); err != nil {
		log.Fatalf("Failed to start FFmpeg: %v", err)
	}

	log.Printf("FFmpeg started, streaming webcam to MediaMTX...")

	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	<-sigChan
	log.Println("Shutting down...")

	if err := cmd.Process.Kill(); err != nil {
		log.Printf("Failed to kill FFmpeg: %v", err)
	}

	cmd.Wait()
	log.Println("Stopped")
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
