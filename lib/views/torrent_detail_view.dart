import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_bytes/pretty_bytes.dart';
import 'package:tor_player/routers/app_routes.dart';

import 'package:torrent/torrent.dart' as torrent;

class TorrentDetailView extends StatelessWidget {
  const TorrentDetailView({
    super.key,
    required this.infoHash,
  });

  final String infoHash;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Torrent Detail'),
      ),
      body: FutureBuilder<torrent.Torrent>(
        future: () async {
          final resp =
              await torrent.LibTorrent().torrentApi.getTorrent(infoHash);
          if (resp == null) {
            throw Exception('Failed to fetch torrent');
          }
          return resp;
        }(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          }

          final torrent = snapshot.data;
          if (torrent == null) {
            return const SizedBox();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${torrent.name}'),
                const SizedBox(height: 10),
                Text('Info Hash: ${torrent.infoHash}'),
                const SizedBox(height: 10),
                Text('Size: ${prettyBytes(torrent.size.toDouble())}'),
                const SizedBox(height: 10),
                filesSection(context, torrent),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget filesSection(BuildContext context, torrent.Torrent torrentFile) {
    if (torrentFile.files.isEmpty) {
      return const Text('No files available');
    }

    return DataTable(
      columns: const [
        DataColumn(label: Text('No')),
        DataColumn(label: Text('File Name')),
        DataColumn(label: Text('Size')),
        DataColumn(label: Text('Actions')),
      ],
      rows: torrentFile.files.asMap().entries.map((entry) {
        final index = entry.key;
        final file = entry.value;
        return DataRow(cells: [
          DataCell(Text(index.toString())),
          DataCell(Text(file.name)),
          DataCell(Text(prettyBytes(file.size.toDouble()))),
          DataCell(Row(
            children: [
              if (isVideoFile(file.name))
                ElevatedButton.icon(
                  onPressed: () async {
                    context.pushNamed(
                      AppRoutes.player,
                      pathParameters: {
                        'infoHash': infoHash,
                        'fileIndex': index.toString(),
                      },
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                ),
            ],
          )),
        ]);
      }).toList(),
    );
  }
}

bool isVideoFile(String fileName) {
  final ext = fileName.split('.').last;
  return ext == 'mp4' || ext == 'mkv' || ext == 'webm';
}
