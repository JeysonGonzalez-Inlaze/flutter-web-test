import 'package:flutter/material.dart';
import 'package:flutter_web_test/src/settings/settings_controller.dart';
import 'package:flutter_web_test/src/settings/settings_service.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';

import '../auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final settingsController = SettingsController(SettingsService());

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 12),
                    child: SettingsContent(
                      settingsController: widget.settingsController,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...[
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          FilledButton(
            onPressed: () {
              BetStoreAuth.of(context).signOut();
            },
            child: const Text('Sign out'),
          ),
          const Text('Example using the Link widget:'),
          Link(
            uri: Uri.parse('/bets/all/bet/0'),
            builder: (context, followLink) => TextButton(
              onPressed: followLink,
              child: const Text('/bets/all/bet/0'),
            ),
          ),
          const Text('Example using GoRouter.of(context).go():'),
          TextButton(
            child: const Text('/bets/all/bet/0'),
            onPressed: () {
              GoRouter.of(context).go('/bets/all/bet/0');
            },
          ),
          DropdownButton<ThemeMode>(
            // Read the selected themeMode from the controller
            value: settingsController.themeMode,
            // Call the updateThemeMode method any time the user selects a theme.
            onChanged: settingsController.updateThemeMode,
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text('System Theme'),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Light Theme'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark Theme'),
              )
            ],
          ),
        ].map((w) => Padding(padding: const EdgeInsets.all(8), child: w)),
        const Text('Displays a dialog on the root Navigator:'),
        TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Alert!'),
              content: const Text('The alert description goes here.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          child: const Text('Show Dialog'),
        )
      ],
    );
  }
}
