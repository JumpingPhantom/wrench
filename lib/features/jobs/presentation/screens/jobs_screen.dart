import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/features/home/presentation/widgets/job_item.dart';
import 'package:wrench/features/jobs/presentation/widgets/job_filter_bar.dart';
import 'package:wrench/l10n/app_localizations.dart';

class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key, this.initialFilter});

  final String? initialFilter;

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  late JobFilter _selectedFilter;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedFilter = _parseFilter(widget.initialFilter);
  }

  JobFilter _parseFilter(String? value) {
    if (value == null) return JobFilter.all;
    return JobFilter.values.firstWhere(
      (f) => f.name == value,
      orElse: () => JobFilter.all,
    );
  }

  List<Job> _applyFilters(List<Job> jobs) {
    final query = _searchQuery.trim().toLowerCase();

    return jobs.where((job) {
      if (!_selectedFilter.matches(job)) return false;
      if (query.isEmpty) return true;

      return job.title.toLowerCase().contains(query) ||
          job.location.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _openCreateJob() async {
    final job = await context.push<Job>('/jobs/new');
    if (job == null || !mounted) return;

    final l10n = AppLocalizations.of(context)!;

    try {
      await ref.read(jobsProvider.notifier).saveJob(job);
    } on OperationException {
      _showError(l10n.photoUploadFailed);
    } on AppException {
      _showError(l10n.jobSaveFailed);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          JobFilterBar(
            l10n: l10n,
            onFilterChanged: (filter) =>
                setState(() => _selectedFilter = filter),
            onSearchChanged: (query) => setState(() => _searchQuery = query),
          ),
          Expanded(
            child: ref
                .watch(jobsProvider)
                .when(
                  data: (jobs) {
                    final filtered = _applyFilters(jobs);
                    if (filtered.isEmpty) {
                      return Center(child: Text(l10n.noJobsFound));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6.0,
                        ),
                        child: JobItem(
                          job: filtered[index],
                          onTap: () => context.push(
                            '/jobs/${filtered[index].id}',
                            extra: filtered[index],
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
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
