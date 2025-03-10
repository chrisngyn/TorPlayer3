import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tor_player/routers/app_routes.dart';

List<(String, Icon)> _getDestinations() {
  return [
    ('Home', const Icon(Icons.home)),
    ('Torrent List', const Icon(Icons.list)),
    ('Settings', const Icon(Icons.settings)),
  ];
}

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 450) {
        return ScaffoldWithNavigationBar(
          selectedIndex: _calculateSelectedIndex(context),
          onDestinationSelected: (index) =>
              _onDestinationSelected(context, index),
          child: child,
        );
      } else {
        return ScaffoldWithNavigationRail(
          selectedIndex: _calculateSelectedIndex(context),
          onDestinationSelected: (index) =>
              _onDestinationSelected(context, index),
          extended: constraints.maxWidth > 600,
          child: child,
        );
      }
    });
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final state = GoRouterState.of(context);
    switch (state.topRoute?.name) {
      case AppRoutes.home:
        return 0;
      case AppRoutes.torrentList:
        return 1;
      case AppRoutes.settings:
        return 2;
    }
    return 0;
  }

  static void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        GoRouter.of(context).goNamed(AppRoutes.home);
        break;
      case 1:
        GoRouter.of(context).goNamed(AppRoutes.torrentList);
        break;
      case 2:
        GoRouter.of(context).goNamed(AppRoutes.settings);
        break;
    }
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final destinations = _getDestinations()
        .map((e) => BottomNavigationBarItem(icon: e.$2, label: e.$1))
        .toList();

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: destinations,
        currentIndex: selectedIndex,
        onTap: onDestinationSelected,
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.extended = true,
  });

  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    final destinations = _getDestinations()
        .map((e) => NavigationRailDestination(icon: e.$2, label: Text(e.$1)))
        .toList();

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            extended: extended,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
