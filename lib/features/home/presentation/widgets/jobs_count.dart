import 'package:flutter/material.dart';

class JobsCount extends StatelessWidget {
  const JobsCount({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.assignment_outlined),
            label: const Text('3 Pending'),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.sync),
            label: const Text('2 In Progress'),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('5 Completed'),
          ),
        ],
      ),
    );
  }
}
