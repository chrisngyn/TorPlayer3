package torrent

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/anacrolix/torrent"
	"github.com/anacrolix/torrent/metainfo"
)

func (m *Manager) AddFromLink(torrentLink string, dropOthers, deleteOthers bool) (InfoHash, error) {
	var (
		tor *torrent.Torrent
		err error
	)

	if dropOthers {
		m.DropAll()
	}

	if deleteOthers {
		err = m.DeleteAll()
		if err != nil {
			return InfoHash{}, fmt.Errorf("delete all: %w", err)
		}
	}

	if strings.HasPrefix(torrentLink, "magnet:") {
		tor, err = m.client.AddMagnet(torrentLink)
		if err != nil {
			return InfoHash{}, err
		}
	} else if strings.HasPrefix(torrentLink, "http") || strings.HasPrefix(torrentLink, "https") {
		resp, err := http.Get(torrentLink)
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
		return InfoHash{}, fmt.Errorf("invalid torrent link")
	}

	// wait for the torrent to be added
	<-tor.GotInfo()

	return InfoHash(tor.InfoHash()), nil
}
