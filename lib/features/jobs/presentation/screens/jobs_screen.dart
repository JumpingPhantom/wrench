import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/features/home/presentation/widgets/job_item.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
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
    var result = jobs;
    if (_selectedFilter == JobFilter.pending) {
      result = result.where((job) => job.status == 'Staged').toList();
    } else if (_selectedFilter != JobFilter.all) {
      result = result
          .where((job) => job.status == _selectedFilter.statusCode)
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result
          .where(
            (job) =>
                job.title.toLowerCase().contains(query) ||
                job.location.toLowerCase().contains(query),
          )
          .toList();
    }
    return result;
  }

  Future<void> _openCreateJob(BuildContext context) async {
    final result = await context.push<Job>('/jobs/new');
    if (result == null || !mounted) return;

    await ref.read(jobsProvider.notifier).saveJob(result);
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
        onPressed: () => _openCreateJob(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.createJob),
      ),
    );
  }
}
