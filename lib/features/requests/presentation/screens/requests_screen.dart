import 'package:flutter/material.dart';
import 'package:wrench/core/utils/seed.dart';
import 'package:wrench/features/home/presentation/widgets/request_item.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  String _searchQuery = '';
  String? _selectedStatus;

  List<Map<String, String>> get _allRequests {
    final requests = <Map<String, String>>[];

    for (final proposal in Seed.proposals) {
      requests.add({
        'title': proposal.title,
        'location': 'Zone 1',
        'status': 'Proposed',
        'time': '3h ago',
      });
    }

    for (final task in Seed.inProgressTasks) {
      requests.add({
        'title': task.proposal.title,
        'location': 'Zone 2',
        'status': 'In Progress',
        'time': '1d ago',
      });
    }

    for (final task in Seed.stagedTasks) {
      requests.add({
        'title': task.task.proposal.title,
        'location': 'Zone 3',
        'status': 'Staged',
        'time': '2d ago',
      });
    }

    for (final task in Seed.finishedTasks) {
      requests.add({
        'title': task.task.task.proposal.title,
        'location': 'Zone 4',
        'status': 'Finished',
        'time': '3d ago',
      });
    }

    for (final task in Seed.rejectedTasks) {
      requests.add({
        'title': task.task.title,
        'location': 'Zone 5',
        'status': 'Rejected',
        'time': '4d ago',
      });
    }

    return requests;
  }

  List<Map<String, String>> get _filteredRequests {
    var requests = _allRequests;

    if (_searchQuery.isNotEmpty) {
      requests = requests
          .where(
            (r) =>
                r['title']!.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (_selectedStatus != null) {
      requests = requests.where((r) => r['status'] == _selectedStatus).toList();
    }

    return requests;
  }

  @override
  Widget build(BuildContext context) {
    final requests = _filteredRequests;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
          child: SearchBar(
            leading: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
            hintText: 'Search requests...',
            elevation: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.focused) ? 2.0 : 0.0,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 40.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              FilterChip(
                label: const Text('All'),
                selected: _selectedStatus == null,
                onSelected: (selected) {
                  setState(() {
                    _selectedStatus = null;
                  });
                },
              ),
              const SizedBox(width: 8.0),
              FilterChip(
                label: const Text('Proposed'),
                selected: _selectedStatus == 'Proposed',
                onSelected: (selected) {
                  setState(() {
                    _selectedStatus = selected ? 'Proposed' : null;
                  });
                },
              ),
              const SizedBox(width: 8.0),
              FilterChip(
                label: const Text('In Progress'),
                selected: _selectedStatus == 'In Progress',
                onSelected: (selected) {
                  setState(() {
                    _selectedStatus = selected ? 'In Progress' : null;
                  });
                },
              ),
              const SizedBox(width: 8.0),
              FilterChip(
                label: const Text('Staged'),
                selected: _selectedStatus == 'Staged',
                onSelected: (selected) {
                  setState(() {
                    _selectedStatus = selected ? 'Staged' : null;
                  });
                },
              ),
              const SizedBox(width: 8.0),
              FilterChip(
                label: const Text('Finished'),
                selected: _selectedStatus == 'Finished',
                onSelected: (selected) {
                  setState(() {
                    _selectedStatus = selected ? 'Finished' : null;
                  });
                },
              ),
              const SizedBox(width: 8.0),
              FilterChip(
                label: const Text('Rejected'),
                selected: _selectedStatus == 'Rejected',
                onSelected: (selected) {
                  setState(() {
                    _selectedStatus = selected ? 'Rejected' : null;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: requests.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48.0,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'No requests found',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 6.0,
                      ),
                      child: RequestItem(request: requests[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
