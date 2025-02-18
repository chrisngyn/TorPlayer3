import 'package:flutter/material.dart';
import 'package:torrent/torrent.dart' as torrent;
import 'package:torrent_example/video_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _textEditingController;
  String? _infoHash;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo torplayer'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  labelText: 'Magnet Link or Torrent Link',
                  hintText: 'Enter a magnet link or torrent link',
                ),
              ),
              spacerSmall,
              TextButton(
                onPressed: () async {
                  final resp = await torrent.LibTorrent().torrentApi.addTorrent(
                        torrent.AddTorrentRequest(
                          link: _textEditingController.text,
                        ),
                        deleteOthers: true,
                      );

                  setState(() {
                    _infoHash = resp?.infoHash;
                    _textEditingController.clear();
                  });
                },
                child: const Text("Add Torrent"),
              ),
              spacerSmall,
              SelectableText('Info Hash: $_infoHash', style: textStyle),
              Visibility(
                visible: _infoHash != null,
                child: TextButton(
                  child: const Text("Open Video"),
                  onPressed: () {
                    final url =
                        "http://localhost:8080/stream/$_infoHash/videos/0/test.mp4";
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return VideoScreen(url: url);
                    }));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
