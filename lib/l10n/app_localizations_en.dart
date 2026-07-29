// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Wrench';

  @override
  String get home => 'Home';

  @override
  String get jobs => 'Jobs';

  @override
  String get analytics => 'Analytics';

  @override
  String get settings => 'Settings';

  @override
  String get overview => 'Overview';

  @override
  String get recentJobs => 'Recent Jobs';

  @override
  String get viewAll => 'View All';

  @override
  String pendingCount(int count) {
    return '$count Pending';
  }

  @override
  String inProgressCount(int count) {
    return '$count In Progress';
  }

  @override
  String completedCount(int count) {
    return '$count Completed';
  }

  @override
  String get searchJobs => 'Search jobs...';

  @override
  String get all => 'All';

  @override
  String get proposed => 'Proposed';

  @override
  String get inProgress => 'In Progress';

  @override
  String get staged => 'Staged';

  @override
  String get finished => 'Finished';

  @override
  String get rejected => 'Rejected';

  @override
  String get noJobsFound => 'No jobs found';

  @override
  String get createPost => 'Create Post';

  @override
  String get title => 'Title';

  @override
  String get enterShortTitle => 'Enter a short title';

  @override
  String get description => 'Description';

  @override
  String get writeContentHere => 'Write your content here...';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get submit => 'Submit';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get createJob => 'New Job';

  @override
  String get jobTitle => 'Job title';

  @override
  String get jobTitleHint => 'e.g. Fix leaking pipe in Zone 4';

  @override
  String get describeTheIssue => 'Describe the issue...';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get addPhotoHint => 'Tap to capture or attach a photo';

  @override
  String get retake => 'Retake';

  @override
  String get removePhoto => 'Remove';

  @override
  String get camera => 'Camera';

  @override
  String get capture => 'Capture';

  @override
  String get usePhoto => 'Use Photo';

  @override
  String get discard => 'Discard';

  @override
  String get unsavedChanges => 'Unsaved Changes';

  @override
  String get discardJobDraft => 'Are you sure you want to discard this job?';

  @override
  String get cancel => 'Cancel';

  @override
  String get requiredField => 'Required';
}
