import 'package:flutter/material.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/presentation/theme/job_status_style.dart';
import 'package:wrench/l10n/app_localizations.dart';

enum JobFilter {
  all,
  draft,
  inProgress,
  staged,
  finished,
  cancelled;

  /// The status this filter narrows to, or null for [all].
  JobStatus? get status => switch (this) {
    all => null,
    draft => JobStatus.draft,
    inProgress => JobStatus.inProgress,
    staged => JobStatus.staged,
    finished => JobStatus.finished,
    cancelled => JobStatus.cancelled,
  };

  /// Named by the status it selects, so a chip and the badge on the card it
  /// reveals never disagree about what to call the same state.
  String label(AppLocalizations l10n) => status?.label(l10n) ?? l10n.all;

  /// Whether [job] belongs under this filter.
  ///
  /// Matching goes through [JobStatus] rather than the translated label, so
  /// filtering keeps working in every locale.
  bool matches(Job job) => status == null || job.status == status;
}

/// Search field and status chips above the jobs list.
///
/// The selection is owned by the screen rather than held here, so a filter
/// arriving on the route ("/jobs?filter=staged") shows up as the selected chip
/// instead of leaving the row reading "All" over a filtered list.
class JobFilterBar extends StatefulWidget {
  const JobFilterBar({
    super.key,
    required this.l10n,
    required this.selected,
    required this.onFilterChanged,
    required this.onSearchChanged,
    this.counts = const {},
  });

  final AppLocalizations l10n;
  final JobFilter selected;

  /// How many jobs each filter would show, given the current search. Absent
  /// while the list is still loading, in which case no counts are drawn.
  final Map<JobFilter, int> counts;

  final ValueChanged<JobFilter> onFilterChanged;
  final ValueChanged<String> onSearchChanged;

  @override
  State<JobFilterBar> createState() => _JobFilterBarState();
}

class _JobFilterBarState extends State<JobFilterBar> {
  final _searchController = TextEditingController();

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
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            style: Theme.of(context).textTheme.bodyLarge,
            onChanged: widget.onSearchChanged,
            decoration: InputDecoration(
              hintText: l10n.searchJobs,
              hintStyle: TextStyle(
                color: colors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              prefixIcon: Icon(Icons.search, color: colors.onSurfaceVariant),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        widget.onSearchChanged('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: colors.surfaceContainerLow,
              border: _border(colors.outlineVariant.withValues(alpha: 0.5)),
              enabledBorder: _border(
                colors.outlineVariant.withValues(alpha: 0.5),
              ),
              focusedBorder: _border(colors.primary, width: 1.5),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 52,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: JobFilter.values.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = JobFilter.values[index];
              return _FilterChip(
                filter: filter,
                selected: widget.selected == filter,
                count: widget.counts[filter],
                onSelected: () => widget.onFilterChanged(filter),
                l10n: l10n,
              );
            },
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

/// One status chip, wearing that status's own colour once it is selected.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.selected,
    required this.count,
    required this.onSelected,
    required this.l10n,
  });

  final JobFilter filter;
  final bool selected;
  final int? count;
  final VoidCallback onSelected;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final status = filter.status;

    // "All" has no status of its own, so it borrows the primary role — the one
    // colour in the scheme no single status claims.
    final style = status == null ? null : JobStatusStyle.of(status, colors);
    final fill = style?.container ?? colors.primaryContainer;
    final onFill = style?.onContainer ?? colors.onPrimaryContainer;
    final foreground = selected ? onFill : colors.onSurfaceVariant;

    return FilterChip(
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onSelected(),
      backgroundColor: colors.surfaceContainerLow,
      selectedColor: fill,
      side: BorderSide(
        color: selected
            ? Colors.transparent
            : colors.outlineVariant.withValues(alpha: 0.5),
      ),
      // The icon appears only on the selected chip: showing six of them at once
      // costs the row's whole width and tells the user nothing they are not
      // already reading in the labels.
      avatar: selected && style != null
          ? Icon(style.icon, size: 16, color: onFill)
          : null,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            filter.label(l10n),
            style: textTheme.labelLarge?.copyWith(
              color: foreground,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 6),
            Text(
              "$count",
              style: textTheme.labelSmall?.copyWith(
                color: foreground.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
