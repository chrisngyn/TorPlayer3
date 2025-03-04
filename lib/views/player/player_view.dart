import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'package:torrent/torrent.dart' as torrent;

class PlayerView extends StatelessWidget {
  const PlayerView({
    super.key,
    required this.infoHash,
    required this.fileIndex,
  });

  final String infoHash;
  final int fileIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player'),
      ),
      body: SingleChildScrollView(
        child: body(),
      ),
    );
  }

  Widget body() {
    return FutureBuilder<torrent.Torrent>(future: () async {
      final resp = await torrent.LibTorrent().torrentApi.getTorrent(infoHash);
      if (resp == null) {
        throw Exception('Failed to fetch torrent');
      }
      return resp;
    }(), builder: (context, snapshot) {
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

      final file = torrent.files[fileIndex];
      return torrentFile(file);
    });
  }

  Widget torrentFile(torrent.File file) {
    final videoURL = torrent.LibTorrent().getStreamURL(
      infoHash,
      fileIndex,
      file.name,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${file.name}'),
        const SizedBox(height: 10),
        VideoPlayer(
          url: videoURL,
        ),
      ],
    );
  }
}

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.url});

  final String url;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();

    player.stream.log.listen((log) {
      debugPrint('Player log: $log');
    });

    // because the torrent file is not ready yet, retry after 3 seconds
    player.stream.error.listen((error) async {
      debugPrint("Player error: $error");
      if (error.contains('Failed to open ')) {
        await Future.delayed(const Duration(seconds: 3));
        _playVideo();
      }
    });

    _playVideo();
  }

  void _playVideo() {
    player.open(Media(widget.url));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isWideScreen = constraints.maxWidth > 600;
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 9.0 / 16.0,
          child: AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Video(
              controller: controller,
              controls: isWideScreen
                  ? MaterialDesktopVideoControls
                  : MaterialVideoControls,
            ),
          ),
        ),
      );
    });
  }
}
