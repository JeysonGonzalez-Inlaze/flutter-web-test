import 'player.dart';
import 'bet.dart';

final betHouseInstance = BetHouse()
  ..addBet(
      name: 'Copa del Rey',
      playerName: 'Jose Diaz',
      isPopular: true,
      isNew: true)
  ..addBet(
      name: 'Liga Colombiana',
      playerName: 'Ada Palmer',
      isPopular: false,
      isNew: true)
  ..addBet(
      name: 'Liga Espa~ola',
      playerName: 'Octavia Deluxe',
      isPopular: true,
      isNew: false)
  ..addBet(
      name: 'Liga Inglesa',
      playerName: 'Jose Diaz',
      isPopular: false,
      isNew: false);

class BetHouse {
  final List<Bet> allBets = [];
  final List<Player> allPlayers = [];

  void addBet({
    required String name,
    required String playerName,
    required bool isPopular,
    required bool isNew,
  }) {
    var player = allPlayers.firstWhere(
      (player) => player.name == playerName,
      orElse: () {
        final value = Player(allPlayers.length, playerName);
        allPlayers.add(value);
        return value;
      },
    );
    var bet = Bet(allBets.length, name, isPopular, isNew, player);

    player.bets.add(bet);
    allBets.add(bet);
  }

  Bet getBet(String id) {
    return allBets[int.parse(id)];
  }

  List<Bet> get popularBets => [
        ...allBets.where((bet) => bet.isPopular),
      ];

  List<Bet> get newBets => [
        ...allBets.where((bet) => bet.isNew),
      ];
}