import 'package:flutter/material.dart';
import 'package:wrench/core/widgets/carved_navigation_button.dart';

@immutable
class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key, required this.onRouteChanged});

  final void Function(String) onRouteChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              onRouteChanged('/');
            },
          ),
          CarvedNavigationButton(onPressed: () {}),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              onRouteChanged('settings');
            },
          ),
        ],
      ),
    );
  }
}
