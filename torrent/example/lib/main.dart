import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:torrent/torrent.dart' as torrent;
import 'package:torrent_example/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const dataDirPath = '/home/chrisngyn/Downloads/TorPlayer';

  @override
  void initState() {
    torrent.LibTorrent().start(dataDirPath, 1);
    super.initState();
  }

  @override
  void dispose() {
    torrent.LibTorrent().stop();
    Directory(dataDirPath).deleteSync(recursive: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 
    return const MaterialApp(
      home: HomePage(),
    );
  }
}



