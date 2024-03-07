import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_web_test/src/settings/settings_view.dart';

class BetStoreScaffold extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const BetStoreScaffold({
    required this.child,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gannar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: AdaptiveNavigationScaffold(
        selectedIndex: selectedIndex,
        body: child,
        onDestinationSelected: (idx) {
          if (idx == 0) goRouter.go('/bets/popular');
          if (idx == 1) goRouter.go('/players');
          if (idx == 2) goRouter.go('/settings');
          if (idx == 3) goRouter.go('/web-socket-channel');
          if (idx == 4) goRouter.go('/socket-io');
        },
        destinations: const [
          AdaptiveScaffoldDestination(
            title: 'Bets',
            icon: Icons.book,
          ),
          AdaptiveScaffoldDestination(
            title: 'Players',
            icon: Icons.person,
          ),
          AdaptiveScaffoldDestination(
            title: 'Settings',
            icon: Icons.settings,
          ),
          AdaptiveScaffoldDestination(
            title: 'Web Socket Channel',
            icon: Icons.sync,
          ),
          AdaptiveScaffoldDestination(
            title: 'Socket.IO',
            icon: Icons.sync_rounded,
          ),
        ],
      ),
    );
  }
}