package torrent

import (
	"github.com/anacrolix/torrent/metainfo"
	"github.com/anacrolix/torrent/types/infohash"
)

type InfoHash metainfo.Hash

func (i InfoHash) String() string {
	return metainfo.Hash(i).String()
}

func InfoHashFromString(infoHashHex string) (InfoHash, error) {
	var infoHash infohash.T
	err := infoHash.FromHexString(infoHashHex)
	return InfoHash(infoHash), err
}

func (i InfoHash) IsZero() bool {
	return i.String() == InfoHash{}.String()
}
