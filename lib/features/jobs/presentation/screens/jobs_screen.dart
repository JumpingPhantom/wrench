import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';
import 'package:wrench/core/utils/seed.dart';
import 'package:wrench/features/home/presentation/widgets/job_item.dart';
import 'package:wrench/features/jobs/presentation/screens/create_job_screen.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String _searchQuery = '';
  String? _selectedStatus;

  List<Map<String, String>> get _allJobs {
    final l10n = AppLocalizations.of(context)!;
    final jobs = <Map<String, String>>[];

    for (final job in Seed.jobs) {
      jobs.add({
        'title': job.title,
        'location': 'Zone 1',
        'status': l10n.proposed,
        'time': '3h ago',
      });
    }

    for (final job in Seed.inProgressJobs) {
      jobs.add({
        'title': job.job.title,
        'location': 'Zone 2',
        'status': l10n.inProgress,
        'time': '1d ago',
      });
    }

    for (final job in Seed.stagedJobs) {
      jobs.add({
        'title': job.job.job.title,
        'location': 'Zone 3',
        'status': l10n.staged,
        'time': '2d ago',
      });
    }

    for (final job in Seed.finishedJobs) {
      jobs.add({
        'title': job.job.job.job.title,
        'location': 'Zone 4',
        'status': l10n.finished,
        'time': '3d ago',
      });
    }

    for (final job in Seed.rejectedJobs) {
      jobs.add({
        'title': job.job.title,
        'location': 'Zone 5',
        'status': l10n.rejected,
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

  void _openCreateJob() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const CreateJobScreen()),
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Job "${result['title']}" created'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _filteredJobs;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final statusFilters = [
      (label: l10n.all, value: null),
      (label: l10n.proposed, value: l10n.proposed),
      (label: l10n.inProgress, value: l10n.inProgress),
      (label: l10n.staged, value: l10n.staged),
      (label: l10n.finished, value: l10n.finished),
      (label: l10n.rejected, value: l10n.rejected),
    ];

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: SearchBar(
              leading: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
              hintText: l10n.searchJobs,
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: statusFilters.length,
              itemBuilder: (context, index) {
                final filter = statusFilters[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(filter.label),
                    selected: _selectedStatus == filter.value,
                    onSelected: (selected) {
                      setState(() {
                        _selectedStatus = selected ? filter.value : null;
                      });
                    },
                  ),
                );
              },
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
                          l10n.noJobsFound,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateJob,
        icon: const Icon(Icons.add),
        label: Text(l10n.createJob),
      ),
    );
  }
}
