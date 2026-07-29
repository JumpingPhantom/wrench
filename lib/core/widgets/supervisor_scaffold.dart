import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class SupervisorScaffold extends StatelessWidget {
  const SupervisorScaffold({super.key, required this.child});

  final Widget child;

  static const _routes = ['/', '/jobs', '/analytics'];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _routes.indexOf(location);
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(child: child),
      appBar: AppBar(
        leading: const Icon(Icons.person),
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => context.go(_routes[index]),
        selectedIndex: _currentIndex(context),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home), label: l10n.home),
          NavigationDestination(
            icon: const Icon(Icons.assignment),
            label: l10n.jobs,
          ),
          NavigationDestination(
            icon: const Icon(Icons.analytics),
            label: l10n.analytics,
          ),
        ],
      ),
    );
  }
}
