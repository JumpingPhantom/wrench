import 'package:flutter/material.dart';
import 'package:wrench/app/router.dart';
import 'package:wrench/app/theme.dart';
import 'package:wrench/app/util.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = createTextTheme(context, 'Inter', 'Inter');

    final theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
