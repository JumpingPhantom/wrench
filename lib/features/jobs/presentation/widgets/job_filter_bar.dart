import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';

enum JobFilter {
  all,
  pending,
  draft,
  inProgress,
  staged,
  finished,
  cancelled;

  String label(AppLocalizations l10n) => switch (this) {
    all => l10n.all,
    pending => l10n.pending,
    draft => l10n.draft,
    inProgress => l10n.inProgress,
    staged => l10n.staged,
    finished => l10n.finished,
    cancelled => l10n.cancelled,
  };

  String? get statusCode => switch (this) {
    all => null,
    pending => null,
    draft => 'Draft',
    inProgress => 'In Progress',
    staged => 'Staged',
    finished => 'Finished',
    cancelled => 'Cancelled',
  };
}

class JobFilterBar extends StatefulWidget {
  const JobFilterBar({
    super.key,
    required this.l10n,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

  final AppLocalizations l10n;
  final ValueChanged<JobFilter> onFilterChanged;
  final ValueChanged<String> onSearchChanged;

  @override
  State<JobFilterBar> createState() => _JobFilterBarState();
}

class _JobFilterBarState extends State<JobFilterBar> {
  final _searchController = TextEditingController();
  JobFilter _selectedFilter = JobFilter.all;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _searchController,
            style: Theme.of(context).textTheme.bodyLarge,
            onChanged: widget.onSearchChanged,
            decoration: InputDecoration(
              hintText: l10n.searchJobs,
              hintStyle: TextStyle(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        widget.onSearchChanged('');
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: JobFilter.values.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = JobFilter.values[index];
              return FilterChip(
                label: Text(filter.label(l10n)),
                selected: _selectedFilter == filter,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedFilter = selected ? filter : JobFilter.all;
                  });
                  widget.onFilterChanged(_selectedFilter);
                },
                showCheckmark: false,
              );
            },
          ),
        ),
      ],
    );
  }
}
