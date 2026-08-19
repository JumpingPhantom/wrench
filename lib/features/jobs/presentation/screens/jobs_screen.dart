import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/widgets/empty_state.dart';
import 'package:wrench/core/presentation/widgets/job_item.dart';
import 'package:wrench/features/jobs/presentation/widgets/job_filter_bar.dart';
import 'package:wrench/l10n/app_localizations.dart';

class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key, this.initialFilter});

  final String? initialFilter;

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  /// How close to the bottom the list gets before the next page is asked for.
  /// Roughly two cards, so the page is usually there by the time it is needed.
  static const _loadMoreThreshold = 400.0;

  /// Long enough that typing a word is one query rather than five.
  static const _searchDebounce = Duration(milliseconds: 350);

  final _scrollController = ScrollController();

  Timer? _debounce;
  late JobFilter _selectedFilter;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedFilter = _parseFilter(widget.initialFilter);
    _scrollController.addListener(_onScroll);

    // The notifier is already building with the default query by the time this
    // screen mounts, so a filter arriving on the route has to be pushed in —
    // and only once the frame that is building has finished.
    if (_selectedFilter != JobFilter.all) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _applyQuery());
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  JobFilter _parseFilter(String? value) {
    if (value == null) return JobFilter.all;
    return JobFilter.values.firstWhere(
      (f) => f.name == value,
      orElse: () => JobFilter.all,
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    try {
      // The notifier drops the call when a page is already in flight or the
      // end has been reached, so the scroll listener can fire freely.
      await ref.read(jobsProvider.notifier).loadMore();
    } on AppException {
      if (!mounted) return;
      _showSnack(AppLocalizations.of(context)!.somethingWentWrong);
    }
  }

  void _applyQuery() {
    ref
        .read(jobsProvider.notifier)
        .setQuery(
          JobsQuery(status: _selectedFilter.status, search: _searchQuery),
        );
  }

  void _onFilterChanged(JobFilter filter) {
    setState(() => _selectedFilter = filter);
    _jumpToTop();
    _applyQuery();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(_searchDebounce, () {
      if (!mounted) return;
      setState(() => _searchQuery = query);
      _jumpToTop();
      _applyQuery();
    });
  }

  /// A new query is a new list, so it starts at the top rather than wherever
  /// the last one had been scrolled to.
  void _jumpToTop() {
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  Future<void> _refresh() async {
    ref.invalidate(jobsProvider);
    await ref.read(jobsProvider.future);
  }

  /// The create screen saves the job itself — and reports its own failures, on
  /// the form the user would otherwise have to fill in again — so all that
  /// comes back here is whether one was filed. The list has already refreshed
  /// by then: [JobsNotifier.saveJob] reloads the first page and drops the
  /// derived counts.
  Future<void> _openCreateJob() async {
    final created = await context.push<bool>('/jobs/new');
    if (created != true || !mounted) return;

    final l10n = AppLocalizations.of(context)!;

    _showSnack(l10n.jobCreated);
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final jobs = ref.watch(jobsProvider);
    final counts = ref.watch(jobStatusCountsProvider(null)).value;

    return Scaffold(
      body: Column(
        children: [
          // The bar stays put through loading and failure, so the chrome does
          // not jump around underneath whatever the list is doing.
          JobFilterBar(
            l10n: l10n,
            selected: _selectedFilter,
            counts: counts == null ? const {} : _chipCounts(counts),
            onFilterChanged: _onFilterChanged,
            onSearchChanged: _onSearchChanged,
          ),
          // Re-running the query keeps the old list on screen, so the only sign
          // of work is this line rather than the list disappearing.
          SizedBox(
            height: 2,
            child: (jobs.value?.reloading ?? false)
                ? const LinearProgressIndicator(minHeight: 2)
                : null,
          ),
          Expanded(
            child: switch (jobs) {
              AsyncValue(value: final page?) => _JobsList(
                page: page,
                controller: _scrollController,
                onRefresh: _refresh,
                l10n: l10n,
              ),
              AsyncError() => _ErrorState(l10n: l10n, onRetry: _refresh),
              _ => const _LoadingList(),
            },
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

  /// Chip counts come from the source's totals, not the loaded pages: a chip
  /// promising 30 jobs has to keep promising 30 before any of them load.
  Map<JobFilter, int> _chipCounts(Map<JobStatus, int> counts) {
    return {
      for (final filter in JobFilter.values)
        filter: filter.status == null
            ? counts.values.fold(0, (sum, count) => sum + count)
            : counts[filter.status] ?? 0,
    };
  }
}

class _JobsList extends StatelessWidget {
  const _JobsList({
    required this.page,
    required this.controller,
    required this.onRefresh,
    required this.l10n,
  });

  final JobsPage page;
  final ScrollController controller;
  final Future<void> Function() onRefresh;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final jobs = page.jobs;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: jobs.isEmpty
          // Still a scrollable, or there would be nothing for the pull-to-
          // refresh gesture to grab when the list is empty.
          ? ListView(
              controller: controller,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  child: _EmptyState(l10n: l10n),
                ),
              ],
            )
          : ListView.separated(
              controller: controller,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              itemCount: jobs.length + 1,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == jobs.length) {
                  return _ListFooter(page: page, l10n: l10n);
                }

                final job = jobs[index];

                return _Reveal(
                  index: index,
                  child: JobItem(
                    job: job,
                    onTap: () => context.push('/jobs/${job.id}', extra: job),
                  ),
                );
              },
            ),
    );
  }
}

/// Closes the list: a spinner while the next page loads, a full stop once
/// there is nothing left to load.
class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.page, required this.l10n});

  final JobsPage page;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (page.loadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
    }

    if (page.hasMore) return const SizedBox(height: 8);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          l10n.endOfList,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
      ),
    );
  }
}

/// Fades a card up into place, a beat later for each one further down.
///
/// The stagger comes from the duration rather than a delay so it needs no
/// controller per row: every card starts at once and they settle in order.
class _Reveal extends StatelessWidget {
  const _Reveal({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      duration: Duration(milliseconds: 220 + 35 * math.min(index, 8)),
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 14),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off,
      title: l10n.noJobsFound,
      message: l10n.noJobsFoundHint,
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.l10n, required this.onRetry});

  final AppLocalizations l10n;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off,
                size: 32,
                color: colors.onErrorContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.somethingWentWrong,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder cards shaped like the real ones, pulsing while jobs load.
///
/// Standing in for the list rather than replacing it with a spinner keeps the
/// screen from collapsing to nothing and then springing back.
class _LoadingList extends StatefulWidget {
  const _LoadingList();

  @override
  State<_LoadingList> createState() => _LoadingListState();
}

class _LoadingListState extends State<_LoadingList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return IgnorePointer(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => FadeTransition(
          opacity: Tween(begin: 0.45, end: 0.85).animate(_controller),
          child: Container(
            height: 104,
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _Block(width: 84, height: 84, radius: 14, color: colors),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Block(width: 160, height: 14, radius: 6, color: colors),
                      _Block(width: 110, height: 12, radius: 6, color: colors),
                      _Block(width: 72, height: 20, radius: 999, color: colors),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({
    required this.width,
    required this.height,
    required this.radius,
    required this.color,
  });

  final double width;
  final double height;
  final double radius;
  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
