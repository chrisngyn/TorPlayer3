import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:tor_player/views/components/buttons.dart';

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

      return torrentVideo(torrent.files, fileIndex);
    });
  }

  Widget torrentVideo(List<torrent.File> files, int videoIndex) {
    final videoFile = files[videoIndex];
    final videoURL = torrent.LibTorrent().getStreamURL(
      infoHash,
      fileIndex,
      videoFile.name,
    );

    final List<UriSubtitle> uriSubittles = [];
    for (final (i, file) in files.indexed) {
      if (isSubitleFile(file.name)) {
        uriSubittles.add(UriSubtitle(
          name: file.name.split("/").last,
          url: torrent.LibTorrent().getStreamURL(
            infoHash,
            i,
            file.name,
          ),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${videoFile.name}'),
        const SizedBox(height: 10),
        VideoPlayer(
          url: videoURL,
          uriSubtitles: uriSubittles,
        ),
      ],
    );
  }
}

bool isSubitleFile(String name) {
  for (final ext in ['srt', 'vtt', 'webm', 'ass']) {
    if (name.endsWith(ext)) {
      return true;
    }
  }
  return false;
}

class UriSubtitle {
  const UriSubtitle({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;
}

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    super.key,
    required this.url,
    this.uriSubtitles = const [],
  });

  final String url;
  final List<UriSubtitle> uriSubtitles;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late final player = Player();
  late final controller = VideoController(player);

  Track? _selectedTrack;
  Tracks? _availableTracks;

  @override
  void initState() {
    super.initState();

    player.stream.log.listen((log) {
      debugPrint('Player log: $log');
    });

    player.stream.tracks.listen((tracks) {
      setState(() {
        _availableTracks ??= tracks;
      });
    });

    player.stream.track.listen((track) {
      setState(() {
        _selectedTrack = track;
      });
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        video(),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              availableTracks(),
              const SizedBox(height: 10),
              uriSubtitles(),
            ],
          ),
        ),
      ],
    );
  }

  Widget video() {
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

  Widget availableTracks() {
    if (_availableTracks == null) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Available videos:'),
        Wrap(
          direction: Axis.horizontal,
          spacing: 10,
          children: _availableTracks!.video.map((track) {
            return elevatedButton(
              text: track.title ?? track.id,
              onPressed: () {
                player.setVideoTrack(track);
              },
              disable: _selectedTrack?.video.id == track.id,
            );
          }).toList(),
        ),
        const Text('Available audios:'),
        Wrap(
          direction: Axis.horizontal,
          spacing: 10,
          children: _availableTracks!.audio.map((track) {
            return elevatedButton(
              text: track.title ?? track.id,
              onPressed: () {
                player.setAudioTrack(track);
              },
              disable: _selectedTrack?.audio.id == track.id,
            );
          }).toList(),
        ),
        const Text('Available subitles:'),
        Wrap(
          direction: Axis.horizontal,
          spacing: 10,
          children: _availableTracks!.subtitle.map((track) {
            return elevatedButton(
              text: track.title ?? track.id,
              onPressed: () {
                player.setSubtitleTrack(track);
              },
              disable: _selectedTrack?.subtitle.id == track.id,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget uriSubtitles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Subtitles:'),
        Wrap(
          alignment: WrapAlignment.start,
          // direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 10,
          runSpacing: 10,
          children: widget.uriSubtitles.map((uriSubtitle) {
            return LoadingElevatedButton(
              text: uriSubtitle.name,
              onPressed: () async {
                _selectUriSubtitle(uriSubtitle);
              },
              disable: _selectedTrack?.subtitle.title == uriSubtitle.name,
              icon: Icons.subtitles,
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _selectUriSubtitle(UriSubtitle subtitle) async {
    // download subtitle file and got content using http package
    HttpClient httpClient = HttpClient();
    HttpClientRequest request =
        await httpClient.getUrl(Uri.parse(subtitle.url));
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String content = await utf8.decodeStream(response);
      player
          .setSubtitleTrack(SubtitleTrack.data(content, title: subtitle.name));
    }
  }
}
