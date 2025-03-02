package torrent

import (
	"fmt"
	"net/http"
	"time"

	"github.com/anacrolix/torrent"
	"github.com/anacrolix/torrent/metainfo"
	"github.com/gabriel-vasile/mimetype"
)

func (m *Manager) GetFile(infoHash InfoHash, fileIndex int) (*torrent.File, error) {
	tor, ok := m.GetTorrent(infoHash)
	if !ok {
		return nil, fmt.Errorf("torrent not found")
	}
	return tor.Files()[fileIndex], nil
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
