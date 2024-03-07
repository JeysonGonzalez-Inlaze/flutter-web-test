import 'player.dart';

class Bet {
  final int id;
  final String name;
  final Player player;
  final bool isPopular;
  final bool isNew;

  Bet(this.id, this.name, this.isPopular, this.isNew, this.player);
}