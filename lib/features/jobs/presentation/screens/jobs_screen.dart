import 'package:flutter/material.dart';
import 'package:wrench/core/utils/seed.dart';
import 'package:wrench/features/home/presentation/widgets/job_item.dart';
import 'package:wrench/features/jobs/presentation/screens/camera_screen.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String _searchQuery = '';
  String? _selectedStatus;

  List<Map<String, String>> get _allJobs {
    final jobs = <Map<String, String>>[];

    for (final job in Seed.jobs) {
      jobs.add({
        'title': job.title,
        'location': 'Zone 1',
        'status': 'Proposed',
        'time': '3h ago',
      });
    }

    for (final job in Seed.inProgressJobs) {
      jobs.add({
        'title': job.job.title,
        'location': 'Zone 2',
        'status': 'In Progress',
        'time': '1d ago',
      });
    }

    for (final job in Seed.stagedJobs) {
      jobs.add({
        'title': job.job.job.title,
        'location': 'Zone 3',
        'status': 'Staged',
        'time': '2d ago',
      });
    }

    for (final job in Seed.finishedJobs) {
      jobs.add({
        'title': job.job.job.job.title,
        'location': 'Zone 4',
        'status': 'Finished',
        'time': '3d ago',
      });
    }

    for (final job in Seed.rejectedJobs) {
      jobs.add({
        'title': job.job.title,
        'location': 'Zone 5',
        'status': 'Rejected',
        'time': '4d ago',
      });
    }

    return jobs;
  }

  List<Map<String, String>> get _filteredJobs {
    var jobs = _allJobs;

    if (_searchQuery.isNotEmpty) {
      jobs = jobs
          .where(
            (j) =>
                j['title']!.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (_selectedStatus != null) {
      jobs = jobs.where((j) => j['status'] == _selectedStatus).toList();
    }

    return jobs;
  }

  void showCustomModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 32,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  Text(
                    'Create Post',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),

                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter a short title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const TextField(
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Write your content here...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      IconButton.outlined(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CameraScreen(),
                          );
                        },
                        icon: const Icon(Icons.photo_camera),
                        tooltip: 'Take Photo',
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _filteredJobs;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: SearchBar(
              leading: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
              hintText: 'Search jobs...',
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
            child: jobs.isEmpty
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
                          'No jobs found',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6.0,
                        ),
                        child: JobItem(job: jobs[index]),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCustomModalBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
