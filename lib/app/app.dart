import 'package:flutter/material.dart';
import 'package:wrench/app/router.dart';
import 'package:wrench/app/theme.dart';
import 'package:wrench/app/util.dart';
import 'package:wrench/core/widgets/bottom_navigation_bar.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    final textTheme = createTextTheme(context, 'Inter', 'Inter');

    final theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      routerConfig: router,
      builder: (context, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBarWidget(
            onRouteChanged: (route) {
              router.go(route);
            },
          ),
        );
      },
    );
  }
}
