import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecentRequestsHeader extends StatelessWidget {
  const RecentRequestsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Requests',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              context.go('/requests');
            },
            child: const Text('View All'),
          ),
        ],
      ),
    );
  }
}
