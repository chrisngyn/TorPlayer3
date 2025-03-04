package http

import (
	"errors"
	"net/http"

	gotorrent "github.com/anacrolix/torrent"
	"github.com/go-chi/render"

	"torrent/torrent"
)

func (s *Server) ListTorrents(w http.ResponseWriter, r *http.Request) {
	torrents := s.torManager.ListTorrents()

	render.Respond(w, r, map[string]any{
		"torrents": toHTTPTorrents(torrents),
	})
}

func (s *Server) AddTorrent(w http.ResponseWriter, r *http.Request) {
	var requestBody AddTorrentJSONRequestBody
	if err := render.DecodeJSON(r.Body, &requestBody); err != nil {
		respondError(w, r, err, http.StatusBadRequest)
		return
	}

	if requestBody.Content == "" {
		respondError(w, r, errors.New("link is required"), http.StatusBadRequest)
		return
	}

	infoHash, err := s.torManager.Add(requestBody.Content)
	if err != nil {
		respondError(w, r, err, http.StatusInternalServerError)
		return
	}

	render.Respond(w, r, map[string]any{
		"infoHash": infoHash.String(),
	})
}

func (s *Server) GetTorrent(w http.ResponseWriter, r *http.Request, infoHash InfoHash) {
	hash, err := torrent.InfoHashFromString(string(infoHash))
	if err != nil {
		respondError(w, r, err, http.StatusBadRequest)
		return
	}
	torrent, ok := s.torManager.GetTorrent(hash)
	if !ok {
		respondError(w, r, errors.New("torrent not found"), http.StatusNotFound)
		return
	}

	render.Respond(w, r, toHTTPTorrent(torrent))
}

func (s *Server) DropAllTorrents(w http.ResponseWriter, r *http.Request, params DropAllTorrentsParams) {
	deleteAllTorrents := false
	if params.Delete != nil {
		deleteAllTorrents = *params.Delete
	}

	s.torManager.DropAll()
	if !deleteAllTorrents {
		w.WriteHeader(http.StatusNoContent)
		return
	}

	err := s.torManager.DeleteAll()
	if err != nil {
		respondError(w, r, err, http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func toHTTPTorrents(torrents []*gotorrent.Torrent) []Torrent {
	httpTorrents := make([]Torrent, len(torrents))
	for i, t := range torrents {
		httpTorrents[i] = toHTTPTorrent(t)
	}
	return httpTorrents
}

func toHTTPTorrent(t *gotorrent.Torrent) Torrent {
	return Torrent{
		InfoHash: t.InfoHash().String(),
		Name:     t.Name(),
		Size:     t.Length(),
		Files:    toHTTPFiles(t.Files()),
	}
}

func toHTTPFiles(files []*gotorrent.File) []File {
	httpFiles := make([]File, len(files))
	for i, f := range files {
		httpFiles[i] = toHTTPFile(f)
	}
	return httpFiles
}

func toHTTPFile(f *gotorrent.File) File {
	return File{
		Name: f.Path(),
		Size: f.Length(),
	}
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
