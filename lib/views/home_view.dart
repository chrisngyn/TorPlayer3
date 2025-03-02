import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final TextEditingController _textEditingController;

  bool _dragging = false;
  DropItem? item;

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

  void _addTorrent() async {
    // final resp = await torrent.LibTorrent().torrentApi.addTorrent(
    //       torrent.AddTorrentRequest(
    //         link: _textEditingController.text,
    //       ),
    //       deleteOthers: true,
    //     );

    // setState(() {
    //   _infoHash = resp?.infoHash;
    //   _textEditingController.clear();
    // });
  }

  @override
  Widget build(BuildContext context) {
    const textSize = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Center(
                child: TextField(
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Magnet Link or Torrent Link',
                    // alignLabelWithHint: true,
                    hintText: 'Enter a magnet link or torrent link',
                  ),
                ),
              ),
              spacerSmall,
              const Text('Or drag and drop a torrent file:'),
              spacerSmall,
              DropTarget(
                onDragDone: (detail) {
                  setState(() {
                    item = detail.files.first;
                  });
                },
                onDragEntered: (detail) {
                  setState(() {
                    _dragging = true;
                  });
                },
                onDragExited: (detail) {
                  setState(() {
                    _dragging = false;
                  });
                },
                child: Container(
                  width: 500,
                  height: 200,
                  decoration: BoxDecoration(
                    color: _dragging
                        ? Theme.of(context).colorScheme.surfaceContainer
                        : Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      _dragging ? 'Drop here' : 'Drag here',
                      style: textSize,
                    ),
                  ),
                ),
              ),
              spacerSmall,
              ElevatedButton(
                onPressed: _addTorrent,
                child: const Text('Add Torrent'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
