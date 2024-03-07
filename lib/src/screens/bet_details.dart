import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';

import '../data.dart';
import 'player_details.dart';

class BetDetailsScreen extends StatelessWidget {
  final Bet? bet;

  const BetDetailsScreen({
    super.key,
    this.bet,
  });

  @override
  Widget build(BuildContext context) {
    if (bet == null) {
      return const Scaffold(
        body: Center(
          child: Text('No bet found.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(bet!.name),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              bet!.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              bet!.player.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              child: const Text('View player (Push)'),
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (context) => PlayerDetailsScreen(
                      player: bet!.player,
                      onBetTapped: (bet) {
                        GoRouter.of(context).go('/bets/all/bet/${bet.id}');
                      },
                    ),
                  ),
                );
              },
            ),
            Link(
              uri: Uri.parse('/players/player/${bet!.player.id}'),
              builder: (context, followLink) => TextButton(
                onPressed: followLink,
                child: const Text('View player (Link)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}