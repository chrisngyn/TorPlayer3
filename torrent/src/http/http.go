package http

import (
	"net/http"

	"github.com/go-chi/render"

	"torrent/torrent"
)

type Server struct {
	torManager *torrent.Manager
}

func NewServer(torManager *torrent.Manager) *Server {
	if torManager == nil {
		panic("torManager is required")
	}
	return &Server{torManager: torManager}
}

func respondError(w http.ResponseWriter, r *http.Request, err error, status int) {
	resp := errorResponse{
		Message:    err.Error(),
		httpStatus: status,
	}

	_ = render.Render(w, r, resp)
}

type errorResponse struct {
	Message    string `json:"message"`
	httpStatus int
}

func (e errorResponse) Render(w http.ResponseWriter, _ *http.Request) error {
	w.WriteHeader(e.httpStatus)
	return nil
}
