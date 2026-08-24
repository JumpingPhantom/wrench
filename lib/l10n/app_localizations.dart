import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Wrench'**
  String get appTitle;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Jobs tab label
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get jobs;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Overview section title
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// Recent jobs section title
  ///
  /// In en, this message translates to:
  /// **'Recent Jobs'**
  String get recentJobs;

  /// View all button text
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Pending jobs count
  ///
  /// In en, this message translates to:
  /// **'{count} Pending'**
  String pendingCount(int count);

  /// In progress jobs count
  ///
  /// In en, this message translates to:
  /// **'{count} In Progress'**
  String inProgressCount(int count);

  /// Completed jobs count
  ///
  /// In en, this message translates to:
  /// **'{count} Completed'**
  String completedCount(int count);

  /// Search bar hint text
  ///
  /// In en, this message translates to:
  /// **'Search jobs...'**
  String get searchJobs;

  /// Filter chip label for all items
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Job status: proposed
  ///
  /// In en, this message translates to:
  /// **'Proposed'**
  String get proposed;

  /// Job status: in progress
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// Job status: staged
  ///
  /// In en, this message translates to:
  /// **'Staged'**
  String get staged;

  /// Job status: finished
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// Job status: rejected
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'No jobs found'**
  String get noJobsFound;

  /// Bottom sheet title for creating a post
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// Title field label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Title field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter a short title'**
  String get enterShortTitle;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Description field hint text
  ///
  /// In en, this message translates to:
  /// **'Write your content here...'**
  String get writeContentHere;

  /// Camera button tooltip
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Submit button text
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Settings section title for appearance
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Create job page title
  ///
  /// In en, this message translates to:
  /// **'New Job'**
  String get createJob;

  /// Job title field label
  ///
  /// In en, this message translates to:
  /// **'Job title'**
  String get jobTitle;

  /// Job title field hint
  ///
  /// In en, this message translates to:
  /// **'e.g. Fix leaking pipe in Zone 4'**
  String get jobTitleHint;

  /// Description field hint
  ///
  /// In en, this message translates to:
  /// **'Describe the issue...'**
  String get describeTheIssue;

  /// Photo section label
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// Photo section hint
  ///
  /// In en, this message translates to:
  /// **'Tap to capture or attach a photo'**
  String get addPhotoHint;

  /// Retake photo button
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// Remove photo button
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removePhoto;

  /// Camera screen title
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Capture photo button
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get capture;

  /// Confirm captured photo
  ///
  /// In en, this message translates to:
  /// **'Use Photo'**
  String get usePhoto;

  /// Discard changes
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// Discard confirmation title
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChanges;

  /// Discard confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to discard this job?'**
  String get discardJobDraft;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Required field indicator
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// Job status: draft
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// Job status: cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Relative time: less than 1 minute ago
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Relative time: minutes ago
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// Relative time: hours ago
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// Relative time: days ago
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// Relative time: weeks ago
  ///
  /// In en, this message translates to:
  /// **'{count}w ago'**
  String weeksAgo(int count);

  /// Relative time: months ago
  ///
  /// In en, this message translates to:
  /// **'{count}mo ago'**
  String monthsAgo(int count);

  /// Job details screen title
  ///
  /// In en, this message translates to:
  /// **'Job Details'**
  String get jobDetails;

  /// Job creator name
  ///
  /// In en, this message translates to:
  /// **'Created by {name}'**
  String createdBy(String name);

  /// Location field label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Job filter: pending (jobs staged and awaiting approval)
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSubtitle;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Invalid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// Fallback when a job's creator cannot be resolved to a profile
  ///
  /// In en, this message translates to:
  /// **'Unknown user'**
  String get unknownUser;

  /// Shown when a job detail page is opened for a job that cannot be found
  ///
  /// In en, this message translates to:
  /// **'This job is no longer available'**
  String get jobNotFound;

  /// Error shown when saving a job to the backend fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the job. Please try again.'**
  String get jobSaveFailed;

  /// Error shown when uploading job media to storage fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t upload the photo. Please try again.'**
  String get photoUploadFailed;

  /// Error shown when the camera fails to capture an image
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t take the photo. Please try again.'**
  String get photoCaptureFailed;

  /// Shown when no camera could be opened on the device
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable'**
  String get cameraUnavailable;

  /// Error shown when submitting a job without an active session
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to create a job'**
  String get notSignedIn;

  /// Action that moves a draft job into progress
  ///
  /// In en, this message translates to:
  /// **'Start Job'**
  String get startJob;

  /// Action that stages an in-progress job for a supervisor to review
  ///
  /// In en, this message translates to:
  /// **'Submit for Approval'**
  String get submitForApproval;

  /// Action that marks a staged job as finished
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approveJob;

  /// Action that cancels a job outright
  ///
  /// In en, this message translates to:
  /// **'Cancel Job'**
  String get cancelJob;

  /// Dismisses the cancellation dialog without cancelling
  ///
  /// In en, this message translates to:
  /// **'Keep Job'**
  String get keepJob;

  /// Body of the job cancellation confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Cancelling a job can\'t be undone. Please give a reason.'**
  String get cancelJobPrompt;

  /// Label of the cancellation reason field
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get cancelReasonLabel;

  /// Hint of the cancellation reason field
  ///
  /// In en, this message translates to:
  /// **'e.g. Reported in error'**
  String get cancelReasonHint;

  /// Validation message when a cancellation reason is left empty
  ///
  /// In en, this message translates to:
  /// **'A reason is required'**
  String get reasonRequired;

  /// Error shown when a job state transition fails to save
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update the job. Please try again.'**
  String get jobUpdateFailed;

  /// Label above the stored reason on a cancelled job
  ///
  /// In en, this message translates to:
  /// **'Cancellation reason'**
  String get cancellationReason;

  /// Who moved the job into progress
  ///
  /// In en, this message translates to:
  /// **'Started by {name}'**
  String startedBy(String name);

  /// Who approved the finished job
  ///
  /// In en, this message translates to:
  /// **'Approved by {name}'**
  String approvedBy(String name);

  /// Who cancelled the job
  ///
  /// In en, this message translates to:
  /// **'Cancelled by {name}'**
  String cancelledBy(String name);

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// User role: supervisor
  ///
  /// In en, this message translates to:
  /// **'Supervisor'**
  String get roleSupervisor;

  /// User role: worker
  ///
  /// In en, this message translates to:
  /// **'Worker'**
  String get roleWorker;

  /// Placeholder text on the not-yet-built profile screen
  ///
  /// In en, this message translates to:
  /// **'Account settings are coming soon.'**
  String get profileComingSoon;

  /// Closes the full-screen photo viewer
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Accessibility label for the tappable job photo
  ///
  /// In en, this message translates to:
  /// **'View photo'**
  String get viewPhoto;

  /// Section heading above the job lifecycle track on the detail screen
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// Section heading above a job's location, creator and actor rows
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Label for when a job was first created, followed by a relative time
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Hint under the empty state on the jobs screen
  ///
  /// In en, this message translates to:
  /// **'Try another filter, or a different search term.'**
  String get noJobsFoundHint;

  /// Title of the error state shown when the jobs list fails to load
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Button that reloads the jobs list after a failure
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Label above the button that advances a job to its next state
  ///
  /// In en, this message translates to:
  /// **'Next step'**
  String get nextStep;

  /// Shown at the foot of the jobs list once every page has loaded
  ///
  /// In en, this message translates to:
  /// **'That\'s all of them'**
  String get endOfList;

  /// Profile section heading above the signed-in user's job counts
  ///
  /// In en, this message translates to:
  /// **'Your jobs'**
  String get yourJobs;

  /// Profile section heading above settings and sign out
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Signs the current user out of the app
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Body of the sign-out confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again to see your jobs.'**
  String get signOutPrompt;

  /// Advance to the next step of the create-job wizard
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Return to the previous step of the create-job wizard
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Create-job wizard: label of the first step
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get stepJob;

  /// Create-job wizard: label of the photo step
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// Create-job wizard: heading of the first step
  ///
  /// In en, this message translates to:
  /// **'What needs doing?'**
  String get whatNeedsDoing;

  /// Create-job wizard: heading of the location step
  ///
  /// In en, this message translates to:
  /// **'Where is it?'**
  String get whereIsIt;

  /// Location picker label
  ///
  /// In en, this message translates to:
  /// **'Choose a location'**
  String get chooseLocation;

  /// Marks a step or field that can be left empty
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Create-job wizard: heading of the summary card
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewJob;

  /// Button that files the new job
  ///
  /// In en, this message translates to:
  /// **'Create job'**
  String get createJobAction;

  /// Confirmation once a new job has been saved
  ///
  /// In en, this message translates to:
  /// **'Job created'**
  String get jobCreated;

  /// Create-job wizard: which step of how many
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepOf(int current, int total);

  /// Empty state title on the overview when nothing has been filed
  ///
  /// In en, this message translates to:
  /// **'No jobs yet'**
  String get noJobsYet;

  /// Empty state hint on the overview
  ///
  /// In en, this message translates to:
  /// **'Create the first job and it will show up here.'**
  String get noJobsYetHint;

  /// Title shown when a request could not reach the backend
  ///
  /// In en, this message translates to:
  /// **'No connection'**
  String get noConnection;

  /// Hint under the offline error state
  ///
  /// In en, this message translates to:
  /// **'You appear to be offline. Check your connection and try again.'**
  String get noConnectionHint;

  /// Notifications screen title, and the app bar button's tooltip
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Empty state title on the notifications screen
  ///
  /// In en, this message translates to:
  /// **'Nothing to catch up on'**
  String get noNotifications;

  /// Empty state hint on the notifications screen
  ///
  /// In en, this message translates to:
  /// **'You\'ll hear here when someone on your team files a job or sends one for approval.'**
  String get noNotificationsHint;

  /// Action that marks every unread notification read
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// Notification line for a job someone created
  ///
  /// In en, this message translates to:
  /// **'{actor} filed a new job'**
  String notificationJobCreated(String actor);

  /// Notification line for a job someone submitted for review
  ///
  /// In en, this message translates to:
  /// **'{actor} sent a job for approval'**
  String notificationJobSubmitted(String actor);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
