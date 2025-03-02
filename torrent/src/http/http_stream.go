package http

import (
	"net/http"

	"github.com/go-chi/render"

	"torrent/torrent"
)

func (s *Server) StreamFile(w http.ResponseWriter, r *http.Request, infoHash InfoHash, fileIndex FileIndex, fileName FileName) {
	infoH, err := torrent.InfoHashFromString(infoHash)
	if err != nil {
		respondError(w, r, err, http.StatusBadRequest)
		return
	}
	if err := s.torManager.StreamFile(w, r, infoH, fileIndex); err != nil {
		respondError(w, r, err, http.StatusInternalServerError)
		return
	}
}

func (s *Server) GetTorrentStats(w http.ResponseWriter, r *http.Request, infoHash InfoHash, fileIndex FileIndex) {
	ih, err := torrent.InfoHashFromString(infoHash)
	if err != nil {
		respondError(w, r, err, http.StatusBadRequest)
		return
	}

	stats := s.torManager.Stats(ih, fileIndex)

	render.Respond(w, r, toHTTPStats(stats))
}
