import 'dart:ui';

import 'package:flutter/material.dart';
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
          debugPrint('Error initializing services: $e');
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
    // Initialize services
    _dataDirPath = '/home/chrisngyn/Downloads/TorPlayer';
    torrent.LibTorrent().start(_dataDirPath, 0);
    _isInitialized = true;
  }

  void _cleanUp() {
    torrent.LibTorrent().stop();
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
