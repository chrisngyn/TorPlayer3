package torrent

import (
	"os"
	"path/filepath"
)

func (m *Manager) DownloadAll(infoHash InfoHash) {
	tor, ok := m.GetTorrent(infoHash)
	if !ok {
		return
	}
	tor.DownloadAll()
}

func (m *Manager) Cancel(infoHash InfoHash) {
	tor, ok := m.GetTorrent(infoHash)
	if !ok {
		return
	}
	tor.CancelPieces(0, tor.NumPieces())
}

func (m *Manager) Delete(infoHash InfoHash) error {
	tor, ok := m.GetTorrent(infoHash)
	if !ok {
		return nil
	}
	tor.Drop()

	return removeContents(filepath.Join(m.config.DataDir, tor.Name()))
}

func (m *Manager) DropAll() {
	for _, tor := range m.client.Torrents() {
		tor.Drop()
	}
}

func (m *Manager) DeleteAll() error {
	m.DropAll()

	return removeContents(m.config.DataDir)
}

func removeContents(dir string) error {
	files, err := os.ReadDir(dir)
	if err != nil {
		return err
	}

	for _, file := range files {
		err = os.RemoveAll(filepath.Join(dir, file.Name()))
		if err != nil {
			return err
		}
	}
	return nil

}
