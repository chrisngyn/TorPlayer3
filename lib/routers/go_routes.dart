import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tor_player/routers/app_routes.dart';
import 'package:tor_player/routers/scaffold_with_nested_navigation.dart';
import 'package:tor_player/views/home_view.dart';
import 'package:tor_player/views/player/player_view.dart';
import 'package:tor_player/views/torrent_detail_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouter = GoRouter(
  initialLocation: "/home",
  // * Passing a navigatorKey causes an issue on hot reload:
  // * https://github.com/flutter/flutter/issues/113757#issuecomment-1518421380
  // * However it's still necessary otherwise the navigator pops back to
  // * root on hot reload
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) =>
          ScaffoldWithNestedNavigation(child: child),
      routes: [
        GoRoute(
          name: AppRoutes.home,
          path: "/home",
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          name: AppRoutes.torrentDetail,
          path: "/torrents/:infoHash",
          builder: (context, state) {
            final infoHash = state.pathParameters['infoHash']!;
            return TorrentDetailView(infoHash: infoHash);
          },
        ),
        GoRoute(
          name: AppRoutes.player,
          path: "/torrents/:infoHash/files/:fileIndex",
          builder: (context, state) {
            final infoHash = state.pathParameters['infoHash']!;
            final fileIndex = int.parse(state.pathParameters['fileIndex']!);
            return PlayerView(infoHash: infoHash, fileIndex: fileIndex);
          },
        ),
      ],
    )
  ],
);
