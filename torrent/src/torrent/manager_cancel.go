package torrent

import (
	"os"
	"path/filepath"
)

func (m *Manager) DropAll() {
	for _, tor := range m.client.Torrents() {
		tor.Drop()
	}
	return
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
