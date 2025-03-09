package http

import (
	"errors"
	"net/http"

	gotorrent "github.com/anacrolix/torrent"
	"github.com/go-chi/render"

	"torrent/torrent"
)

func (s *Server) GetTorrentFileStats(w http.ResponseWriter, r *http.Request, infoHash InfoHash, fileIndex FileIndex) {
	ih, err := torrent.InfoHashFromString(infoHash)
	if err != nil {
		respondError(w, r, err, http.StatusBadRequest)
		return
	}

	stats := s.torManager.Stats(ih, fileIndex)

	render.Respond(w, r, toHTTPStats(stats))
}

func (s *Server) GetTorrentStats(w http.ResponseWriter, r *http.Request, infoHash InfoHash) {
	ih, err := torrent.InfoHashFromString(infoHash)
	if err != nil {
		respondError(w, r, err, http.StatusBadRequest)
		return
	}

	torrent, ok := s.torManager.GetTorrent(ih)
	if !ok {
		respondError(w, r, errors.New("torrent not found"), http.StatusNotFound)
		return
	}

	render.Respond(w, r, toHTTPTorrentStats(torrent))
}

func toHTTPStats(stats torrent.Stats) Stats {
	return Stats{
		ActivePeers:    stats.ActivePeers,
		BytesCompleted: stats.BytesCompleted,
		ConnectedPeers: stats.ConnectedSeeders,
		HalfOpenPeers:  stats.HalfOpenPeers,
		Length:         stats.Length,
		PendingPeers:   stats.PendingPeers,
		TotalPeers:     stats.TotalPeers,
	}
}

func toHTTPTorrentStats(torrent *gotorrent.Torrent) TorrentStats {
	files := make([]TorrentStatsFile, 0, len(torrent.Files()))
	for _, f := range torrent.Files() {
		files = append(files, TorrentStatsFile{
			BytesCompleted: f.BytesCompleted(),
			Length:         f.Length(),
		})
	}
	return TorrentStats{
		Files: files,
		Stats: Stats{
			ActivePeers:    torrent.Stats().ActivePeers,
			BytesCompleted: torrent.BytesCompleted(),
			ConnectedPeers: torrent.Stats().ConnectedSeeders,
			HalfOpenPeers:  torrent.Stats().HalfOpenPeers,
			Length:         torrent.Length(),
			PendingPeers:   torrent.Stats().PendingPeers,
			TotalPeers:     torrent.Stats().TotalPeers,
		},
	}

}
