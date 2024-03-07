import 'package:flutter/widgets.dart';

class BetStoreAuth extends ChangeNotifier {
  bool _signedIn = false;

  bool get signedIn => _signedIn;

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    _signedIn = false;
    notifyListeners();
  }

  Future<bool> signIn(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Sign in. Allow any password.
    _signedIn = true;
    notifyListeners();
    return _signedIn;
  }

  @override
  bool operator ==(Object other) =>
      other is BetStoreAuth && other._signedIn == _signedIn;

  @override
  int get hashCode => _signedIn.hashCode;

  static BetStoreAuth of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<BetStoreAuthScope>()!
      .notifier!;
}

class BetStoreAuthScope extends InheritedNotifier<BetStoreAuth> {
  const BetStoreAuthScope({
    required super.notifier,
    required super.child,
    super.key,
  });
}