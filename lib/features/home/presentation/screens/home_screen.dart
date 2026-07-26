import 'package:flutter/material.dart';
import 'package:wrench/features/home/presentation/widgets/overview_title.dart';
import 'package:wrench/features/home/presentation/widgets/recent_requests_body.dart';
import 'package:wrench/features/home/presentation/widgets/recent_requests_header.dart';
import 'package:wrench/features/home/presentation/widgets/requests_count.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> requests = [
      {
        'title': 'Broken Pipe - Main Line',
        'location': 'Zone 4 • Sector B',
        'status': 'Proposed',
        'time': '2h ago',
      },
      {
        'title': 'Leaking HVAC - Branc...',
        'location': 'Zone 2 • Roof',
        'status': 'In Progress',
        'time': '5h ago',
      },
      {
        'title': 'Electrical Panel Spark',
        'location': 'Zone 1 • Lobby',
        'status': 'Approved',
        'time': '1d ago',
      },
      {
        'title': 'Conveyor Belt Seized',
        'location': 'Zone 5 • Assembly',
        'status': 'Proposed',
        'time': 'Just Now',
      },
    ];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          OverviewTitle(),
          RequestsCount(),
          const SizedBox(height: 16.0),
          RecentRequestsHeader(),
          const SizedBox(height: 8.0),
          RecentRequestsBody(requests: requests),
        ],
      ),
    );
  }
}
