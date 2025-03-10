import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tor_player/services/preferences/preferences_service.dart';
import 'package:torrent/torrent.dart' as torrent;

class LifecycleManager extends StatefulWidget {
  const LifecycleManager({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<LifecycleManager> createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends State<LifecycleManager>
    with WidgetsBindingObserver {
  late final String _dataDirPath;
  bool _isInitialized = false;
  Exception? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.delayed(Duration.zero, _initServices).whenComplete(() {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }).catchError((e) {
      _error = e;
      if (mounted) {
        setState(() {
          log('Error initializing services: $e');
          _error = e;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    _cleanUp();
    return super.didRequestAppExit();
  }

  Future<void> _initServices() async {
    _dataDirPath = PreferencesService.getInstance().dataDir;
    log("Starting libtorrent with data dir: $_dataDirPath");
    torrent.LibTorrent().start(_dataDirPath, 0);
  }

  void _cleanUp() {
    log("Cleaning up services");
    torrent.LibTorrent().stop();
    if (PreferencesService.getInstance().deleteAfterClose) {
      _deleteDataDir();
    }
  }

  void _deleteDataDir() {
    log("Deleting data dir: $_dataDirPath");
    final dataDir = Directory(_dataDirPath);
    final contents = dataDir.listSync();
    for (final entity in contents) {
      try {
        if (entity is File) {
          entity.deleteSync();
        } else if (entity is Directory) {
          entity.deleteSync(recursive: true);
        }
      } catch (e) {
        log("Failed to delete entity: $entity, error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Text('Error initializing services: $_error'),
      );
    }

    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return widget.child;
  }
}
