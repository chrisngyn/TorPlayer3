import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_bytes/pretty_bytes.dart';
import 'package:tor_player/routers/app_routes.dart';
import 'package:tor_player/views/torrents/torrent_actions.dart';

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

          return _TorrentList(torrents: snapshot.data!);
        },
      ),
    );
  }
}

class _TorrentList extends StatefulWidget {
  const _TorrentList({required this.torrents});
  final List<torrent.Torrent> torrents;

  @override
  State<_TorrentList> createState() => __TorrentListState();
}

class __TorrentListState extends State<_TorrentList> {
  late List<torrent.Torrent> _torrents;

  @override
  void initState() {
    super.initState();
    _torrents = List.from(widget.torrents);
  }

  void _deleteTorrent(int index) {
    setState(() {
      _torrents.removeAt(index);
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (_torrents.isEmpty) {
      return const Center(
        child: Text('No torrents found'),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: _torrents.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final torrent = _torrents[index];
          return _TorrentInfo(
            aTorrent: torrent,
            onDeleted: () => _deleteTorrent(index),
          );
        },
      ),
    );
  }
}
class _TorrentInfo extends StatefulWidget {
  const _TorrentInfo({required this.aTorrent, required this.onDeleted});

  final torrent.Torrent aTorrent;
  final Function() onDeleted;

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
    torrent.TorrentStats? newTorrentStats;
    try {
      newTorrentStats = await torrent.LibTorrent()
          .torrentApi
          .getTorrentStats(widget.aTorrent.infoHash);
    } catch (e) {
      debugPrint('Failed to fetch torrent stats: $e');
    }

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
              const SizedBox(height: 8),
              TorrentActions(
                infoHash: widget.aTorrent.infoHash,
                onDeleted: () => widget.onDeleted(),
              )
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
