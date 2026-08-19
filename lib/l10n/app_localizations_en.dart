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

  @override
  String get draft => 'Draft';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String weeksAgo(int count) {
    return '${count}w ago';
  }

  @override
  String monthsAgo(int count) {
    return '${count}mo ago';
  }

  @override
  String get jobDetails => 'Job Details';

  @override
  String createdBy(String name) {
    return 'Created by $name';
  }

  @override
  String get location => 'Location';

  @override
  String get pending => 'Pending';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get unknownUser => 'Unknown user';

  @override
  String get jobNotFound => 'This job is no longer available';

  @override
  String get jobSaveFailed => 'Couldn\'t save the job. Please try again.';

  @override
  String get photoUploadFailed =>
      'Couldn\'t upload the photo. Please try again.';

  @override
  String get photoCaptureFailed =>
      'Couldn\'t take the photo. Please try again.';

  @override
  String get cameraUnavailable => 'Camera unavailable';

  @override
  String get notSignedIn => 'You need to be signed in to create a job';

  @override
  String get startJob => 'Start Job';

  @override
  String get submitForApproval => 'Submit for Approval';

  @override
  String get approveJob => 'Approve';

  @override
  String get cancelJob => 'Cancel Job';

  @override
  String get keepJob => 'Keep Job';

  @override
  String get cancelJobPrompt =>
      'Cancelling a job can\'t be undone. Please give a reason.';

  @override
  String get cancelReasonLabel => 'Reason';

  @override
  String get cancelReasonHint => 'e.g. Reported in error';

  @override
  String get reasonRequired => 'A reason is required';

  @override
  String get jobUpdateFailed => 'Couldn\'t update the job. Please try again.';

  @override
  String get cancellationReason => 'Cancellation reason';

  @override
  String startedBy(String name) {
    return 'Started by $name';
  }

  @override
  String approvedBy(String name) {
    return 'Approved by $name';
  }

  @override
  String cancelledBy(String name) {
    return 'Cancelled by $name';
  }

  @override
  String get profile => 'Profile';

  @override
  String get roleSupervisor => 'Supervisor';

  @override
  String get roleWorker => 'Worker';

  @override
  String get profileComingSoon => 'Account settings are coming soon.';

  @override
  String get close => 'Close';

  @override
  String get viewPhoto => 'View photo';

  @override
  String get progress => 'Progress';

  @override
  String get details => 'Details';

  @override
  String get created => 'Created';

  @override
  String get noJobsFoundHint =>
      'Try another filter, or a different search term.';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get nextStep => 'Next step';

  @override
  String get endOfList => 'That\'s all of them';

  @override
  String get yourJobs => 'Your jobs';

  @override
  String get account => 'Account';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutPrompt => 'You\'ll need to sign in again to see your jobs.';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get stepJob => 'Job';

  @override
  String get photo => 'Photo';

  @override
  String get whatNeedsDoing => 'What needs doing?';

  @override
  String get whereIsIt => 'Where is it?';

  @override
  String get chooseLocation => 'Choose a location';

  @override
  String get optional => 'Optional';

  @override
  String get reviewJob => 'Review';

  @override
  String get createJobAction => 'Create job';

  @override
  String get jobCreated => 'Job created';

  @override
  String stepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get noJobsYet => 'No jobs yet';

  @override
  String get noJobsYetHint => 'Create the first job and it will show up here.';
}
