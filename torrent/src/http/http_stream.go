package http

import (
	"net/http"

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

func (s *Server) StreamVideoFile(w http.ResponseWriter, r *http.Request, infoHash InfoHash, fileIndex FileIndex, fileName FileName) {
	infoH, err := torrent.InfoHashFromString(infoHash)
	if err != nil {
		respondError(w, r, err, http.StatusBadRequest)
		return
	}
	if err := s.torManager.StreamVideoFile(w, r, infoH, fileIndex); err != nil {
		respondError(w, r, err, http.StatusInternalServerError)
		return
	}
}
