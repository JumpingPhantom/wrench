import 'package:flutter/material.dart';

class CarvedNavigationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CarvedNavigationButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Material(
        color: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Icon(
              Icons.camera_alt,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
