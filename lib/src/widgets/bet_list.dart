import 'package:flutter/material.dart';

import '../data.dart';

class BetList extends StatelessWidget {
  final List<Bet> bets;
  final ValueChanged<Bet>? onTap;

  const BetList({
    required this.bets,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: bets.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            bets[index].name,
          ),
          subtitle: Text(
            bets[index].player.name,
          ),
          onTap: onTap != null ? () => onTap!(bets[index]) : null,
        ),
      );
}