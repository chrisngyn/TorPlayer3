import 'package:flutter/material.dart';

import 'package:torrent/torrent.dart' as torrent;

class TorrentActions extends StatelessWidget {
  const TorrentActions({
    super.key,
    required this.infoHash,
    required this.onDeleted,
  });

  final String infoHash;
  final Function() onDeleted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            await torrent.LibTorrent().torrentApi.downloadTorrent(infoHash);
          },
          icon: const Icon(Icons.download),
          label: const Text('Download'),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () async {
            await torrent.LibTorrent().torrentApi.cancelTorrent(infoHash);
          },
          icon: const Icon(Icons.pause),
          label: const Text('Cancel'),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () async {
            await torrent.LibTorrent().torrentApi.deleteTorrent(infoHash);
            onDeleted();
          },
          icon: const Icon(Icons.delete),
          label: const Text('Delete'),
        ),
      ],
    );
  }
}
