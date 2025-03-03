// Package http provides primitives to interact with the openapi HTTP API.
//
// Code generated by github.com/oapi-codegen/oapi-codegen/v2 version v2.4.1 DO NOT EDIT.
package http

// File defines model for File.
type File struct {
	// Name File name
	Name string `json:"name"`

	// Size File size
	Size int64 `json:"size"`
}

// Stats defines model for Stats.
type Stats struct {
	// ActivePeers Active peers
	ActivePeers int `json:"activePeers"`

	// BytesCompleted Bytes completed
	BytesCompleted int64 `json:"bytesCompleted"`

	// ConnectedPeers Connected peers
	ConnectedPeers int `json:"connectedPeers"`

	// HalfOpenPeers Half open peers
	HalfOpenPeers int `json:"halfOpenPeers"`

	// Length Length
	Length int64 `json:"length"`

	// PendingPeers Pending peers
	PendingPeers int `json:"pendingPeers"`

	// TotalPeers Total peers
	TotalPeers int `json:"totalPeers"`
}

// Torrent defines model for Torrent.
type Torrent struct {
	Files []File `json:"files"`

	// InfoHash Torrent info hash
	InfoHash string `json:"infoHash"`

	// Name Torrent name
	Name string `json:"name"`

	// Size Torrent size
	Size int64 `json:"size"`
}

// FileIndex defines model for fileIndex.
type FileIndex = int

// FileName defines model for fileName.
type FileName = string

// InfoHash defines model for infoHash.
type InfoHash = string

// DropAllTorrentsParams defines parameters for DropAllTorrents.
type DropAllTorrentsParams struct {
	// Delete Delete torrents
	Delete *bool `form:"delete,omitempty" json:"delete,omitempty"`
}

// AddTorrentJSONBody defines parameters for AddTorrent.
type AddTorrentJSONBody struct {
	// Content Torrent link or magnet or torrent file content
	Content string `json:"content"`
}

// AddTorrentJSONRequestBody defines body for AddTorrent for application/json ContentType.
type AddTorrentJSONRequestBody AddTorrentJSONBody
