import 'dart:convert';
import 'dart:developer';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cross_file/cross_file.dart';
import 'package:tor_player/routers/app_routes.dart';
import 'package:tor_player/views/components/buttons.dart';
import 'package:torrent/torrent.dart' as torrent;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final TextEditingController _textEditingController;
  XFile? _file;

  Exception? _error;

  bool get _hasContent =>
      _textEditingController.text.isNotEmpty || _file != null;

  Future<String?> _getContent() async {
    if (!_hasContent) {
      return null;
    }

    String content;
    if (_file != null) {
      final bytes = await _file!.readAsBytes();
      content = base64Encode(bytes);
    } else {
      content = _textEditingController.text;
    }

    return content;
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      setState(() {}); // Update the UI when the text changes
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _addTorrent() async {
    if (!_hasContent) {
      setState(() {
        _error = Exception('No content to add');
      });
      return;
    }

    final content = await _getContent();
    if (content == null) {
      setState(() {
        _error = Exception('No content to add');
      });
      return;
    }

    try {
      final resp = await torrent.LibTorrent().torrentApi.addTorrent(
            torrent.AddTorrentRequest(
              content: content,
            ),
          );
      log('Added torrent: $resp');

      setState(() {
        _error = null;
        _textEditingController.clear();
        _file = null;
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
      log('Error adding torrent: $e');
      setState(() {
        _error = e as Exception;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              _FileSelector(onFileSelected: (file) {
                setState(() {
                  _file = file;
                });
              }),
              if (_file != null) ...[
                spacerSmall,
                Text('Selected file: ${_file!.name}'),
              ],
              spacerSmall,
              if (_error != null) ...[
                Text('Error adding torrent: $_error'),
                spacerSmall,
              ],
              LoadingElevatedButton(
                text: "Add torrent",
                onPressed: _addTorrent,
                disable: !_hasContent,
                icon: Icons.add,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FileSelector extends StatefulWidget {
  const _FileSelector({required this.onFileSelected});

  final Function(XFile) onFileSelected;

  @override
  State<_FileSelector> createState() => __FileSelectorState();
}

class __FileSelectorState extends State<_FileSelector> {
  bool _dragging = false;

  void _selectFile(XFile file) {
    widget.onFileSelected(file);
  }

  @override
  Widget build(BuildContext context) {
    const textSize = TextStyle(fontSize: 25);
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['torrent'],
            );
            if (result == null) {
              return;
            }
            _selectFile(result.xFiles.first);
          },
          label: const Text('Select file'),
          icon: const Icon(Icons.file_upload),
        ),
        const SizedBox(height: 10),
        DropTarget(
          onDragDone: (detail) {
            _selectFile(detail.files.first);
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
      ],
    );
  }
}
