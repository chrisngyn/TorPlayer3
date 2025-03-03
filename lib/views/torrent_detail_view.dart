import 'package:flutter/material.dart';

class TorrentDetailView extends StatefulWidget {
  const TorrentDetailView({
    super.key,
    required this.infoHash,
  });

  final String infoHash;

  @override
  State<TorrentDetailView> createState() => _TorrentDetailViewState();
}

class _TorrentDetailViewState extends State<TorrentDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Torrent Detail'),
      ),
      body: Center(
        child: Text('Info Hash: ${widget.infoHash}'),
      ),
    );
  }
}
