import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pretty_bytes/pretty_bytes.dart';

import 'package:torrent/torrent.dart' as torrent;

class FileStats extends StatefulWidget {
  const FileStats({
    super.key,
    required this.infoHash,
    required this.fileIndex,
  });

  final String infoHash;
  final int fileIndex;

  @override
  State<FileStats> createState() => _FileStatsState();
}

class _FileStatsState extends State<FileStats> {
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
    final newStats = await torrent.LibTorrent()
        .torrentApi
        .getTorrentFileStats(widget.infoHash, widget.fileIndex);

    setState(() {
      _verlocityBytesPerSecond =
          (newStats?.bytesCompleted ?? 0) - (_stats?.bytesCompleted ?? 0);
      _stats = newStats;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_stats == null) {
      return const SizedBox();
    }

    final textStyle = Theme.of(context).textTheme.labelSmall;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total peers: ${_stats!.totalPeers}", style: textStyle),
            Text("Active peers: ${_stats!.activePeers}", style: textStyle),
            Text("Connected peers: ${_stats!.connectedPeers}",
                style: textStyle),
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
            Text("Pending peers: ${_stats!.pendingPeers}", style: textStyle),
            Text("Half open peers: ${_stats!.halfOpenPeers}", style: textStyle),
          ],
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Downloaded: ${_stats!.prettyBytesCompleted} / ${_stats!.prettyLength}',
                style: textStyle),
            Text('Progress: ${_stats!.progressPercentage.toStringAsFixed(2)}%',
                style: textStyle),
            Text('Speed: ${prettyBytes(_verlocityBytesPerSecond.toDouble())}/s',
                style: textStyle),
          ],
        ),
      ],
    );
  }
}

extension on torrent.Stats {
  String get prettyBytesCompleted {
    return prettyBytes(bytesCompleted.toDouble());
  }

  String get prettyLength {
    return prettyBytes(length.toDouble());
  }

  double get progressPercentage {
    if (length == 0) {
      return 0;
    }
    return bytesCompleted.toDouble() / length.toDouble() * 100;
  }
}
