import 'package:flutter/material.dart';

import '../data.dart';
import '../widgets/bet_list.dart';

class PlayerDetailsScreen extends StatelessWidget {
  final Player player;
  final ValueChanged<Bet> onBetTapped;

  const PlayerDetailsScreen({
    super.key,
    required this.player,
    required this.onBetTapped,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(player.name),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: BetList(
                  bets: player.bets,
                  onTap: (bet) {
                    onBetTapped(bet);
                  },
                ),
              ),
            ],
          ),
        ),
      );
}