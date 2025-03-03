import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tor_player/routers/app_routes.dart';
import 'package:torrent/torrent.dart' as torrent;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final TextEditingController _textEditingController;

  bool _dragging = false;
  DropItem? _item;

  bool _adding = false;
  Exception? _error;

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
    setState(() {
      _adding = true;
    });
    try {
      final resp = await torrent.LibTorrent().torrentApi.addTorrent(
            torrent.AddTorrentRequest(
              link: _textEditingController.text,
            ),
            deleteOthers: false,
          );
      debugPrint('Added torrent: $resp');

      setState(() {
        _error = null;
        _textEditingController.clear();
        _item = null;
      });

      if (resp == null) {
        return;
      }

      if (!mounted) {
        return;
      }

      await context.pushNamed(
        AppRoutes.torrentDetail,
        pathParameters: {
          'infoHash': resp.infoHash,
        },
      );
    } catch (e) {
      debugPrint('Error adding torrent: $e');
      _error = e as Exception?;
    } finally {
      setState(() {
        _adding = false;
      });
    }
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
                    hintText: 'Enter a magnet link or torrent link',
                    isCollapsed: true,
                  ),
                  maxLines: null,
                ),
              ),
              spacerSmall,
              const Text('Or drag and drop a torrent file:'),
              spacerSmall,
              DropTarget(
                onDragDone: (detail) {
                  setState(() {
                    _item = detail.files.first;
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
              if (_error != null) ...[
                Text('Error adding torrent: $_error'),
                spacerSmall,
              ],
              ElevatedButton.icon(
                onPressed: _addTorrent,
                label: const Text('Add Torrent'),
                icon: _adding
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
