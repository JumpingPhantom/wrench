import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SupervisorScaffold extends StatelessWidget {
  const SupervisorScaffold({super.key, required this.child});

  final Widget child;

  static const _routes = ['/', '/requests', '/analytics'];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _routes.indexOf(location);
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      appBar: AppBar(
        leading: Icon(Icons.person),
        title: Text('Wrench'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => context.go(_routes[index]),
        selectedIndex: _currentIndex(context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.assignment),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.camera),
      ),
    );
  }
}
