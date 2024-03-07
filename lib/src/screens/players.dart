import 'package:flutter/material.dart';

import '../data/player.dart';
import '../data/bet_house.dart';
import '../widgets/player_list.dart';

class PlayersScreen extends StatelessWidget {
  final String title;
  final ValueChanged<Player> onTap;

  const PlayersScreen({
    required this.onTap,
    this.title = 'Players',
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: PlayerList(
          players: betHouseInstance.allPlayers,
          onTap: onTap,
        ),
      );
}