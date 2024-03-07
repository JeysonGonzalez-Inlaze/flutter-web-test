import 'package:flutter/material.dart';

import '../data.dart';

class PlayerList extends StatelessWidget {
  final List<Player> players;
  final ValueChanged<Player>? onTap;

  const PlayerList({
    required this.players,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            players[index].name,
          ),
          subtitle: Text(
            '${players[index].bets.length} bets',
          ),
          onTap: onTap != null ? () => onTap!(players[index]) : null,
        ),
      );
}