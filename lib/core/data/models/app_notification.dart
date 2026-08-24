import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/core/data/models/instant.dart';
import 'package:wrench/l10n/app_localizations.dart';

part "app_notification.freezed.dart";
part "app_notification.g.dart";

/// What a notification is about.
///
/// Stored as the string in [JsonValue], the way [UserRole] is: nothing queries
/// notifications by kind, so this needs no `storedName` table of its own. A
/// value the app does not know throws while the row is parsed, which
/// [parseRows] logs and skips -- one unreadable notification costs one entry.
enum NotificationKind {
  /// A worker filed a job.
  @JsonValue('job_created')
  jobCreated,

  /// A worker submitted a job for approval.
  @JsonValue('job_submitted')
  jobSubmitted,
}

/// One thing a user should be told about.
///
/// Named for the app rather than the domain because `Notification` is a Flutter
/// framework class, and a model sharing that name would collide in every file
/// that imports both.
///
/// Carries no text. The app renders in English and Arabic through
/// `AppLocalizations`, so a stored sentence would be readable in one locale
/// only; what is stored is who did what to which job, and the widget composes
/// the sentence from that.
@freezed
abstract class AppNotification with _$AppNotification {
  const AppNotification._();

  const factory AppNotification({
    required int id,
    required String recipientId,

    /// Who caused it. Null once that profile is gone.
    String? actorId,
    required int jobId,
    required NotificationKind kind,
    @UtcDateTime() required DateTime createdAt,

    /// When the recipient read this, or null while it is unread.
    @NullableUtcDateTime() DateTime? readAt,
  }) = _AppNotification;

  bool get isRead => readAt != null;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

extension NotificationKindLine on NotificationKind {
  /// The sentence this notification reads as, with [actor] named in it.
  ///
  /// Composed here rather than stored, because the row has to render in both
  /// locales and a stored sentence can only be written in one.
  String line(AppLocalizations l10n, String actor) => switch (this) {
    NotificationKind.jobCreated => l10n.notificationJobCreated(actor),
    NotificationKind.jobSubmitted => l10n.notificationJobSubmitted(actor),
  };
}
