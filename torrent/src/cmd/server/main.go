package main

import (
	"errors"
	"log/slog"
	stdhttp "net/http"
	"os"
	"os/signal"
	"strconv"

	"torrent/http"
	"torrent/torrent"
)

var (
	// state
	_torManager *torrent.Manager
	_httpServer *stdhttp.Server
	_listenPort = 8080
)

func main() {
	dataDir := "/home/chrisngyn/Desktop/test"

	slog.Info("Starting torrent server", slog.String("dataDir", dataDir))
	config := torrent.Config{
		DataDir:         dataDir,
		Debug:           true,
	}
	_torManager = torrent.NewManager(config)

	_httpServer = &stdhttp.Server{
		Addr:    ":" + strconv.Itoa(_listenPort),
		Handler: http.HandlerFromMux(http.NewServer(_torManager), http.NewChiRouter()),
	}

	go func() {
		slog.Info("Starting HTTP server", slog.Int("port", _listenPort))
		if err := _httpServer.ListenAndServe(); err != nil && !errors.Is(err, stdhttp.ErrServerClosed) {
			slog.Error("Failed to start HTTP server", slog.Any("error", err))
		}
	}()

	sig := make(chan os.Signal, 1)
	signal.Notify(sig, os.Interrupt)
	<-sig

	if err := _httpServer.Close(); err != nil {
		slog.Error("Failed to close HTTP server", slog.Any("error", err))
	}
	if err := _torManager.Close(); err != nil {
		slog.Error("Failed to close torrent manager", slog.Any("error", err))
	}

}
