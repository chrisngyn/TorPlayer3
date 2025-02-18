package torrent

import (
	"errors"
	"fmt"

	"github.com/anacrolix/torrent"
)

type Manager struct {
	config Config
	client *torrent.Client
}

func NewManager(config Config) *Manager {
	if err := config.validate(); err != nil {
		panic(fmt.Sprintf("invalid config: %v", err))
	}

	cfg := torrent.NewDefaultClientConfig()
	cfg.DataDir = config.DataDir
	cfg.Debug = config.Debug

	client, err := torrent.NewClient(cfg)
	if err != nil {
		panic(fmt.Sprintf("create torrent client: %v", err))
	}

	return &Manager{
		config: config,
		client: client,
	}
}

func (m *Manager) Close() error {
	if m.client != nil {
		errs := m.client.Close()
		return errors.Join(errs...)
	}
	return nil
}
