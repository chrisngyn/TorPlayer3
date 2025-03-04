package torrent

import (
	"bytes"
	"encoding/base64"
	"fmt"
	"net/http"
	"strings"

	"github.com/anacrolix/torrent"
	"github.com/anacrolix/torrent/metainfo"
)

func (m *Manager) Add(content string) (InfoHash, error) {
	var (
		tor *torrent.Torrent
		err error
	)

	if strings.HasPrefix(content, "magnet:") {
		tor, err = m.client.AddMagnet(content)
		if err != nil {
			return InfoHash{}, err
		}
	} else if strings.HasPrefix(content, "http") || strings.HasPrefix(content, "https") {
		resp, err := http.Get(content)
		if err != nil {
			return InfoHash{}, fmt.Errorf("get torrent file: %w", err)
		}
		defer resp.Body.Close()
		info, err := metainfo.Load(resp.Body)
		if err != nil {
			return InfoHash{}, fmt.Errorf("load metainfo: %w", err)
		}
		tor, err = m.client.AddTorrent(info)
		if err != nil {
			return InfoHash{}, fmt.Errorf("add torrent: %w", err)
		}
	} else {
		data, err := base64.StdEncoding.DecodeString(content)
		if err != nil {
			return InfoHash{}, fmt.Errorf("decode base64: %w", err)
		}
		info, err := metainfo.Load(bytes.NewReader(data))
		if err != nil {
			return InfoHash{}, fmt.Errorf("load metainfo: %w", err)
		}
		tor, err = m.client.AddTorrent(info)
		if err != nil {
			return InfoHash{}, fmt.Errorf("add torrent: %w", err)
		}
	}

	// wait for the torrent to be added
	<-tor.GotInfo()

	return InfoHash(tor.InfoHash()), nil
}
