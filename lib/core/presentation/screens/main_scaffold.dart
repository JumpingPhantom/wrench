import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/presentation/controllers/notifications_provider.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.child});

  final Widget child;

  static const _routes = ['/', '/jobs'];

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
        leading: IconButton(
          icon: const Icon(Icons.person),
          tooltip: l10n.profile,
          onPressed: () => context.push('/profile'),
        ),
        title: Text(l10n.appTitle),
        actions: [
          const _NotificationsButton(),
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
        ],
      ),
    );
  }
}

/// The bell, carrying however many notifications have not been read.
///
/// A consumer of its own rather than part of [MainScaffold] so a change to the
/// count rebuilds the button and not the whole shell — every screen in the app
/// sits underneath this scaffold.
class _NotificationsButton extends ConsumerWidget {
  const _NotificationsButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // A count that has not loaded, or failed to, reads as nothing to catch up
    // on: the badge is an invitation, and an error belongs on the screen behind
    // it rather than as a number nobody can act on.
    final unread = ref.watch(unreadNotificationCountProvider).value ?? 0;

    return IconButton(
      tooltip: l10n.notifications,
      onPressed: () => context.push('/notifications'),
      icon: Badge.count(
        count: unread,
        isLabelVisible: unread > 0,
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}
