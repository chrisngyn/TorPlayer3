package main

import "C"
import (
	"errors"
	"log/slog"
	stdhttp "net/http"
	"strconv"

	"torrent/http"
	"torrent/torrent"
)

var (
	// state
	_torManager *torrent.Manager
	_httpServer *stdhttp.Server
	_listenPort int = 8080
)

//export Start
func Start(dataDir string, debug bool) int {
	slog.Info("Starting torrent server", slog.String("dataDir", dataDir), slog.Bool("debug", debug))
	config := torrent.Config{
		DataDir: dataDir,
		Debug:   debug,
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

	return _listenPort
}

//export Stop
func Stop() {
	if err := _httpServer.Close(); err != nil {
		slog.Error("Failed to close HTTP server", slog.Any("error", err))
	}
	if err := _torManager.Close(); err != nil {
		slog.Error("Failed to close torrent manager", slog.Any("error", err))
	}
}

func main() {}
