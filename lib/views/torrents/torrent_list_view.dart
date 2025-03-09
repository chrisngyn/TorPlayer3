import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_bytes/pretty_bytes.dart';
import 'package:tor_player/routers/app_routes.dart';

import 'package:torrent/torrent.dart' as torrent;

class TorrentListView extends StatelessWidget {
  const TorrentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Torrent List'),
      ),
      body: FutureBuilder<List<torrent.Torrent>>(
        future: () async {
          final resp = await torrent.LibTorrent().torrentApi.listTorrents();
          if (resp == null) {
            throw Exception('Failed to fetch torrents');
          }
          return resp.torrents;
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

          return torrentList(context, snapshot.data!);
        },
      ),
    );
  }

  Widget torrentList(BuildContext context, List<torrent.Torrent> torrents) {
    if (torrents.isEmpty) {
      return const Center(
        child: Text('No torrents found'),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: torrents.length,
        itemBuilder: (context, index) {
          final torrent = torrents[index];
          return _TorrentInfo(aTorrent: torrent);
        },
      ),
    );
  }
}

class _TorrentInfo extends StatefulWidget {
  const _TorrentInfo({required this.aTorrent});

  final torrent.Torrent aTorrent;

  @override
  State<_TorrentInfo> createState() => __TorrentInfoState();
}

class __TorrentInfoState extends State<_TorrentInfo> {
  late final Timer _timer;

  torrent.Stats? _stats;
  int _verlocityBytesPerSecond = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (_) async => await _updateStats());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _updateStats() async {
    final newTorrentStats = await torrent.LibTorrent()
        .torrentApi
        .getTorrentStats(widget.aTorrent.infoHash);

    final newStats = newTorrentStats?.stats;
    if (newStats == null) {
      setState(() {
        _stats = null;
        _verlocityBytesPerSecond = 0;
      });
      return;
    }

    setState(() {
      _verlocityBytesPerSecond =
          newStats.bytesCompleted - (_stats?.bytesCompleted ?? 0);
      _stats = newStats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).colorScheme.surfaceContainer,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${widget.aTorrent.name}'),
              Text('Info Hash: ${widget.aTorrent.infoHash}'),
              Text(
                  'Downloaded: ${prettyBytes((_stats?.bytesCompleted ?? 0).toDouble())}/${prettyBytes(widget.aTorrent.size.toDouble())}'),
              Text(
                  'Speed: ${prettyBytes(_verlocityBytesPerSecond.toDouble())}/s'),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              context.pushNamed(
                AppRoutes.torrentDetail,
                pathParameters: {
                  'infoHash': widget.aTorrent.infoHash,
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
