package torrent

type Stats struct {
	TotalPeers       int
	PendingPeers     int
	ActivePeers      int
	ConnectedSeeders int
	HalfOpenPeers    int
	Length           int64
	BytesCompleted   int64
}

func (s Stats) IsZero() bool {
	return s == Stats{}
}

func (m *Manager) Stats(infoHash InfoHash, fileIndex int) Stats {
	tor, ok := m.GetTorrent(infoHash)
	if !ok {
		return Stats{}
	}
	stats := tor.Stats()
	file := tor.Files()[fileIndex]
	return Stats{
		TotalPeers:       stats.TotalPeers,
		PendingPeers:     stats.PendingPeers,
		ActivePeers:      stats.ActivePeers,
		ConnectedSeeders: stats.ConnectedSeeders,
		HalfOpenPeers:    stats.HalfOpenPeers,
		Length:           file.Length(),
		BytesCompleted:   file.BytesCompleted(),
	}
}

func (m *Manager) StatsVideoFile(infoHash InfoHash, configuredIndex int) Stats {
	file, err := m.GetVideoFile(infoHash, configuredIndex)
	if err != nil {
		return Stats{}
	}

	stats := file.Torrent().Stats()

	return Stats{
		TotalPeers:       stats.TotalPeers,
		PendingPeers:     stats.PendingPeers,
		ActivePeers:      stats.ActivePeers,
		ConnectedSeeders: stats.ConnectedSeeders,
		HalfOpenPeers:    stats.HalfOpenPeers,
		Length:           file.Length(),
		BytesCompleted:   file.BytesCompleted(),
	}
}
