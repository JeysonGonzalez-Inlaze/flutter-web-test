import 'bet.dart';

class Player {
  final int id;
  final String name;
  final bets = <Bet>[];

  Player(this.id, this.name);
}