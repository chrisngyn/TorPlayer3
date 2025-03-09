import 'dart:async';

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
                Text('Name: ${torrent.name}',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),
                Text('Info Hash: ${torrent.infoHash}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .merge(const TextStyle(fontStyle: FontStyle.italic))),
                const SizedBox(height: 10),
                _TorrentDetail(aTorrent: torrent)
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TorrentDetail extends StatefulWidget {
  const _TorrentDetail({required this.aTorrent});

  final torrent.Torrent aTorrent;

  @override
  State<_TorrentDetail> createState() => __TorrentDetailState();
}

class __TorrentDetailState extends State<_TorrentDetail> {
  late final Timer _timer;

  torrent.TorrentStats? _torrentStats;
  int _verlocityBytesPerSecond = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (timer) async => await _fetchStats());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchStats() async {
    final stats = await torrent.LibTorrent()
        .torrentApi
        .getTorrentStats(widget.aTorrent.infoHash);
    setState(() {
      _verlocityBytesPerSecond = (stats?.stats.bytesCompleted ?? 0) -
          (_torrentStats?.stats.bytesCompleted ?? 0);
      _torrentStats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        torrentStats(),
        const SizedBox(width: 10),
        filesSection(context),
      ],
    );
  }

  Widget torrentStats() {
    if (_torrentStats == null) {
      return const SizedBox();
    }

    final textStyle = Theme.of(context).textTheme.labelSmall;

    final stats = _torrentStats!.stats;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total peers: ${stats.totalPeers}", style: textStyle),
            Text("Active peers: ${stats.activePeers}", style: textStyle),
            Text("Connected peers: ${stats.connectedPeers}", style: textStyle),
          ],
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "",
              style: textStyle,
            ), // Spacer
            Text("Pending peers: ${stats.pendingPeers}", style: textStyle),
            Text("Half open peers: ${stats.halfOpenPeers}", style: textStyle),
          ],
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Downloaded: ${prettyBytes(stats.bytesCompleted.toDouble())} / ${prettyBytes(stats.length.toDouble())}',
                style: textStyle),
            Text(
                'Progress: ${(stats.length > 0 ? stats.bytesCompleted.toDouble() / stats.length.toDouble() : 0).toStringAsFixed(2)}%',
                style: textStyle),
            Text('Speed: ${prettyBytes(_verlocityBytesPerSecond.toDouble())}/s',
                style: textStyle),
          ],
        ),
      ],
    );
  }

  Widget filesSection(BuildContext context) {
    if (widget.aTorrent.files.isEmpty) {
      return const Text('No files available');
    }

    return Column(
      children: widget.aTorrent.files.asMap().entries.map((entry) {
        final index = entry.key;
        final file = entry.value;
        final fileStats = _torrentStats?.files[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
              child: Text((index + 1).toString()),
            ),
            title: Text(file.path),
            subtitle: Text(
              "${prettyBytes(fileStats?.bytesCompleted.toDouble() ?? 0)} / ${prettyBytes(file.length.toDouble())}",
            ),
            trailing: isVideoFile(file.path)
                ? ElevatedButton.icon(
                    onPressed: () async {
                      context.pushNamed(
                        AppRoutes.player,
                        pathParameters: {
                          'infoHash': widget.aTorrent.infoHash,
                          'fileIndex': index.toString(),
                        },
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}

bool isVideoFile(String fileName) {
  final ext = fileName.split('.').last;
  return ext == 'mp4' || ext == 'mkv' || ext == 'webm';
}
