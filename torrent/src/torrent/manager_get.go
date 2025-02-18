package torrent

import (
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/gabriel-vasile/mimetype"

	"github.com/anacrolix/torrent"
	"github.com/anacrolix/torrent/metainfo"
)

func (m *Manager) GetFile(infoHash InfoHash, fileIndex int) (*torrent.File, error) {
	tor, ok := m.GetTorrent(infoHash)
	if !ok {
		return nil, fmt.Errorf("torrent not found")
	}
	return tor.Files()[fileIndex], nil
}

// GetVideoFile returns the video file of the torrent with the given info hash.
// If configuredIndex not right, it will find the video file and return it.
func (m *Manager) GetVideoFile(infoHash InfoHash, configuredIndex int) (*torrent.File, error) {
	tor, ok := m.GetTorrent(infoHash)
	if !ok {
		return nil, fmt.Errorf("torrent not found")
	}

	files := tor.Files()
	totalFiles := len(files)

	// If configuredIndex is out of range, set it to the first or last file index.
	if configuredIndex < 0 {
		configuredIndex = 0
	}
	if configuredIndex >= totalFiles {
		configuredIndex = totalFiles - 1
	}

	// If the configured file is a video file, return it.
	if isVideoFile(files[configuredIndex].DisplayPath()) {
		return files[configuredIndex], nil
	}

	// Otherwise, find the first video file and return it.
	for _, file := range files {
		if isVideoFile(file.DisplayPath()) {
			return file, nil
		}
	}

	return nil, fmt.Errorf("video file not found")
}

func isVideoFile(path string) bool {
	return strings.HasSuffix(path, ".mp4") || strings.HasSuffix(path, ".mkv") || strings.HasSuffix(path, ".avi")
}

func (m *Manager) GetTorrent(infoHash InfoHash) (*torrent.Torrent, bool) {
	tor, ok := m.client.Torrent(metainfo.Hash(infoHash))
	if !ok {
		return nil, false
	}
	<-tor.GotInfo()
	return tor, true
}

func (m *Manager) ListTorrents() []*torrent.Torrent {
	return m.client.Torrents()
}

func (m *Manager) StreamVideoFile(w http.ResponseWriter, r *http.Request, infoHash InfoHash, fileIndex int) error {
	file, err := m.GetVideoFile(infoHash, fileIndex)
	if err != nil {
		return fmt.Errorf("get video file: %w", err)
	}

	file.Download()
	reader := file.NewReader()
	reader.SetResponsive()

	mime, err := mimetype.DetectReader(reader)
	if err != nil {
		return fmt.Errorf("detect mime type: %w", err)
	} else {
		w.Header().Set("Content-Type", mime.String())
	}

	http.ServeContent(w, r, file.DisplayPath(), time.Time{}, reader)
	return nil
}

func (m *Manager) StreamFile(w http.ResponseWriter, r *http.Request, infoHash InfoHash, fileIndex int) error {
	file, err := m.GetFile(infoHash, fileIndex)
	if err != nil {
		return fmt.Errorf("get file: %w", err)
	}

	file.Download()
	reader := file.NewReader()
	reader.SetResponsive()

	mime, err := mimetype.DetectReader(reader)
	if err != nil {
		return fmt.Errorf("detect mime type: %w", err)
	} else {
		w.Header().Set("Content-Type", mime.String())
	}

	http.ServeContent(w, r, file.DisplayPath(), time.Time{}, reader)
	return nil
}
