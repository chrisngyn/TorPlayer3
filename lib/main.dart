import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tor_player/lifecycle_manager.dart';
import 'package:tor_player/routers/go_routes.dart';
import 'package:tor_player/services/preferences/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  log("Initializing preferences service");
  await PreferencesService.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LifecycleManager(
      child: MaterialApp.router(
        title: 'Tor Player',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        routerConfig: goRouter,
      ),
    );
  }
}
