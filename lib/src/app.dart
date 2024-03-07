// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_web_test/src/menu/item.dart';

// // import 'sample_feature/sample_item_details_view.dart';
// // import 'sample_feature/sample_item_list_view.dart';
// import 'settings/settings_controller.dart';
// import 'settings/settings_view.dart';
// import 'menu/item_details_view.dart';
// import 'menu/item_list_view.dart';

// /// The Widget that configures your application.
// class MyApp extends StatelessWidget {
//   const MyApp({
//     super.key,
//     required this.settingsController,
//   });

//   final SettingsController settingsController;

//   @override
//   Widget build(BuildContext context) {
//     // Glue the SettingsController to the MaterialApp.
//     //
//     // The ListenableBuilder Widget listens to the SettingsController for changes.
//     // Whenever the user updates their settings, the MaterialApp is rebuilt.
//     return ListenableBuilder(
//       listenable: settingsController,
//       builder: (BuildContext context, Widget? child) {
//         return MaterialApp(
//           // Providing a restorationScopeId allows the Navigator built by the
//           // MaterialApp to restore the navigation stack when a user leaves and
//           // returns to the app after it has been killed while running in the
//           // background.
//           restorationScopeId: 'app',

//           // Provide the generated AppLocalizations to the MaterialApp. This
//           // allows descendant Widgets to display the correct translations
//           // depending on the user's locale.
//           localizationsDelegates: const [
//             AppLocalizations.delegate,
//             GlobalMaterialLocalizations.delegate,
//             GlobalWidgetsLocalizations.delegate,
//             GlobalCupertinoLocalizations.delegate,
//           ],
//           supportedLocales: const [
//             Locale('en', ''), // English, no country code
//           ],

//           // Use AppLocalizations to configure the correct application title
//           // depending on the user's locale.
//           //
//           // The appTitle is defined in .arb files found in the localization
//           // directory.
//           onGenerateTitle: (BuildContext context) =>
//               AppLocalizations.of(context)!.appTitle,

//           // Define a light and dark color theme. Then, read the user's
//           // preferred ThemeMode (light, dark, or system default) from the
//           // SettingsController to display the correct theme.
//           theme: ThemeData(),
//           darkTheme: ThemeData.dark(),
//           themeMode: settingsController.themeMode,

//           // Define a function to handle named routes in order to support
//           // Flutter web url navigation and deep linking.
//           onGenerateRoute: (RouteSettings routeSettings) {
//             /* return MaterialPageRoute<void>(
//               settings: routeSettings,
//               builder: (BuildContext context) {
//                 switch (routeSettings.name) {
//                   case SettingsView.routeName:
//                     return SettingsView(controller: settingsController);
//                   case SampleItemDetailsView.routeName:
//                     return const SampleItemDetailsView();
//                   case SampleItemListView.routeName:
//                   default:
//                     return const SampleItemListView();
//                 }
//               },
//             ); */

//             return MaterialPageRoute<void>(
//               settings: routeSettings,
//               builder: (BuildContext context) {
//                 switch (routeSettings.name) {
//                   case SettingsView.routeName:
//                     return SettingsView(controller: settingsController);
//                   case ItemDetailsView.routeName:
//                     return const ItemDetailsView(
//                       payload: Item(1, 'Detail'),
//                     );
//                   case ItemListView.routeName:
//                   default:
//                     return const ItemListView();
//                 }
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth.dart';
import 'data.dart';

import 'screens/player_details.dart';
import 'screens/players.dart';
import 'screens/bet_details.dart';
import 'screens/bets.dart';
import 'screens/scaffold.dart';
import 'screens/settings.dart';
import 'screens/sign_in.dart';

import 'widgets/bet_list.dart';
import 'widgets/fade_transition_page.dart';

import 'web_socket/socket_io_screen.dart';
import 'web_socket/web_socket_channel_screen.dart';

import 'settings/settings_controller.dart';

final appShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'app shell');
final betsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'bets shell');

class App extends StatefulWidget {
  const App({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final BetStoreAuth auth = BetStoreAuth();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: widget.settingsController.themeMode,
      builder: (context, child) {
        if (child == null) {
          throw ('No child in .router constructor builder');
        }
        return BetStoreAuthScope(
          notifier: auth,
          child: child,
        );
      },
      routerConfig: GoRouter(
        refreshListenable: auth,
        debugLogDiagnostics: true,
        initialLocation: '/bets/popular',
        redirect: (context, state) {
          final signedIn = BetStoreAuth.of(context).signedIn;
          if (state.uri.toString() != '/sign-in' && !signedIn) {
            return '/sign-in';
          }
          return null;
        },
        routes: [
          ShellRoute(
            navigatorKey: appShellNavigatorKey,
            builder: (context, state, child) {
              return BetStoreScaffold(
                selectedIndex: switch (state.uri.path) {
                  var p when p.startsWith('/bets') => 0,
                  var p when p.startsWith('/players') => 1,
                  var p when p.startsWith('/settings') => 2,
                  var p when p.startsWith('/web-socket-channel') => 3,
                  var p when p.startsWith('/socket-io') => 4,
                  _ => 0,
                },
                child: child,
              );
            },
            routes: [
              ShellRoute(
                pageBuilder: (context, state, child) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    // Use a builder to get the correct BuildContext
                    // TODO (johnpryan): remove when https://github.com/flutter/flutter/issues/108177 lands
                    child: Builder(builder: (context) {
                      return BetsScreen(
                        onTap: (idx) {
                          GoRouter.of(context).go(switch (idx) {
                            0 => '/bets/popular',
                            1 => '/bets/new',
                            2 => '/bets/all',
                            _ => '/bets/popular',
                          });
                        },
                        selectedIndex: switch (state.uri.path) {
                          var p when p.startsWith('/bets/popular') => 0,
                          var p when p.startsWith('/bets/new') => 1,
                          var p when p.startsWith('/bets/all') => 2,
                          _ => 0,
                        },
                        child: child,
                      );
                    }),
                  );
                },
                routes: [
                  GoRoute(
                    path: '/bets/popular',
                    pageBuilder: (context, state) {
                      return FadeTransitionPage<dynamic>(
                        // Use a builder to get the correct BuildContext
                        // TODO (johnpryan): remove when https://github.com/flutter/flutter/issues/108177 lands
                        key: state.pageKey,
                        child: Builder(
                          builder: (context) {
                            return BetList(
                              bets: betHouseInstance.popularBets,
                              onTap: (bet) {
                                GoRouter.of(context)
                                    .go('/bets/popular/bet/${bet.id}');
                              },
                            );
                          },
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'bet/:betId',
                        parentNavigatorKey: appShellNavigatorKey,
                        builder: (context, state) {
                          return BetDetailsScreen(
                            bet: betHouseInstance
                                .getBet(state.pathParameters['betId'] ?? ''),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: '/bets/new',
                    pageBuilder: (context, state) {
                      return FadeTransitionPage<dynamic>(
                        key: state.pageKey,
                        // Use a builder to get the correct BuildContext
                        // TODO (johnpryan): remove when https://github.com/flutter/flutter/issues/108177 lands
                        child: Builder(
                          builder: (context) {
                            return BetList(
                              bets: betHouseInstance.newBets,
                              onTap: (bet) {
                                GoRouter.of(context)
                                    .go('/bets/new/bet/${bet.id}');
                              },
                            );
                          },
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'bet/:betId',
                        parentNavigatorKey: appShellNavigatorKey,
                        builder: (context, state) {
                          return BetDetailsScreen(
                            bet: betHouseInstance
                                .getBet(state.pathParameters['betId'] ?? ''),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: '/bets/all',
                    pageBuilder: (context, state) {
                      return FadeTransitionPage<dynamic>(
                        key: state.pageKey,
                        // Use a builder to get the correct BuildContext
                        // TODO (johnpryan): remove when https://github.com/flutter/flutter/issues/108177 lands
                        child: Builder(
                          builder: (context) {
                            return BetList(
                              bets: betHouseInstance.allBets,
                              onTap: (bet) {
                                GoRouter.of(context)
                                    .go('/bets/all/bet/${bet.id}');
                              },
                            );
                          },
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'bet/:betId',
                        parentNavigatorKey: appShellNavigatorKey,
                        builder: (context, state) {
                          return BetDetailsScreen(
                            bet: betHouseInstance
                                .getBet(state.pathParameters['betId'] ?? ''),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: '/players',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: Builder(builder: (context) {
                      return PlayersScreen(
                        onTap: (player) {
                          GoRouter.of(context)
                              .go('/players/player/${player.id}');
                        },
                      );
                    }),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'player/:playerId',
                    builder: (context, state) {
                      final player = betHouseInstance.allPlayers.firstWhere(
                          (player) =>
                              player.id ==
                              int.parse(state.pathParameters['playerId']!));
                      // Use a builder to get the correct BuildContext
                      // TODO (johnpryan): remove when https://github.com/flutter/flutter/issues/108177 lands
                      return Builder(builder: (context) {
                        return PlayerDetailsScreen(
                          player: player,
                          onBetTapped: (bet) {
                            GoRouter.of(context).go('/bets/all/bet/${bet.id}');
                          },
                        );
                      });
                    },
                  )
                ],
              ),
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: SettingsScreen(
                      settingsController: widget.settingsController,
                    ),
                  );
                },
              ),
              GoRoute(
                path: '/web-socket-channel',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: const WebSocketScreen10(),
                  );
                },
              ),
              GoRoute(
                path: '/socket-io',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: const SocketIOScreen(),
                    // child: const MessageHandler(),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/sign-in',
            builder: (context, state) {
              // Use a builder to get the correct BuildContext
              // TODO (johnpryan): remove when https://github.com/flutter/flutter/issues/108177 lands
              return Builder(
                builder: (context) {
                  return SignInScreen(
                    onSignIn: (value) async {
                      final router = GoRouter.of(context);
                      await BetStoreAuth.of(context)
                          .signIn(value.username, value.password);
                      router.go('/bets/popular');
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
