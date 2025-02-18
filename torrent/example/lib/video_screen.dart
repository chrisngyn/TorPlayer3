import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoScreen extends StatefulWidget {
  final String url;
  const VideoScreen({super.key, required this.url});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late final Player player;
  late final VideoController controller;
  String? _url;

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);
    player.open(Media(widget.url));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
    print("Video screen disposed");
  }

  void openUrl(String url) {
    if (_url == url) {
      return;
    }
    _url = url;
    player.open(Media(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 9.0 / 16.0,
              child: Video(
                controller: controller,
                controls: MaterialDesktopVideoControls,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
