// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مفتاح';

  @override
  String get home => 'الرئيسية';

  @override
  String get jobs => 'المهام';

  @override
  String get settings => 'الإعدادات';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get recentJobs => 'المهام الأخيرة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String pendingCount(int count) {
    return '$count معلقة';
  }

  @override
  String inProgressCount(int count) {
    return '$count قيد التنفيذ';
  }

  @override
  String completedCount(int count) {
    return '$count مكتملة';
  }

  @override
  String get searchJobs => 'بحث في المهام...';

  @override
  String get all => 'الكل';

  @override
  String get proposed => 'مقترحة';

  @override
  String get inProgress => 'قيد التنفيذ';

  @override
  String get staged => 'مُعدّة';

  @override
  String get finished => 'مكتملة';

  @override
  String get rejected => 'مرفوضة';

  @override
  String get noJobsFound => 'لم يتم العثور على مهام';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get title => 'العنوان';

  @override
  String get enterShortTitle => 'أدخل عنواناً قصيراً';

  @override
  String get description => 'الوصف';

  @override
  String get writeContentHere => 'اكتب محتواك هنا...';

  @override
  String get takePhoto => 'التقط صورة';

  @override
  String get submit => 'إرسال';

  @override
  String get appearance => 'المظهر';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'السمة';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get system => 'النظام';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get createJob => 'عمل جديد';

  @override
  String get jobTitle => 'عنوان العمل';

  @override
  String get jobTitleHint => 'مثال: إصلاح أنبوب متسرب في المنطقة 4';

  @override
  String get describeTheIssue => 'صف المشكلة...';

  @override
  String get addPhoto => 'إضافة صورة';

  @override
  String get addPhotoHint => 'اضغط للتقاط أو إرفاق صورة';

  @override
  String get retake => 'إعادة التقاط';

  @override
  String get removePhoto => 'إزالة';

  @override
  String get camera => 'الكاميرا';

  @override
  String get capture => 'التقاط';

  @override
  String get usePhoto => 'استخدام الصورة';

  @override
  String get discard => 'تجاهل';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get discardJobDraft => 'هل أنت متأكد أنك تريد تجاهل هذا العمل؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get draft => 'مسودة';

  @override
  String get cancelled => 'ملغاة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(int count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(int count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(int count) {
    return 'منذ $count ي';
  }

  @override
  String weeksAgo(int count) {
    return 'منذ $count أ';
  }

  @override
  String monthsAgo(int count) {
    return 'منذ $count ش';
  }

  @override
  String get jobDetails => 'تفاصيل العمل';

  @override
  String createdBy(String name) {
    return 'أنشأه $name';
  }

  @override
  String get location => 'الموقع';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get loginSubtitle => 'تسجيل الدخول للمتابعة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get unknownUser => 'مستخدم غير معروف';

  @override
  String get jobNotFound => 'هذه المهمة لم تعد متاحة';

  @override
  String get jobSaveFailed => 'تعذّر حفظ المهمة. يرجى المحاولة مرة أخرى.';

  @override
  String get photoUploadFailed => 'تعذّر رفع الصورة. يرجى المحاولة مرة أخرى.';

  @override
  String get photoCaptureFailed =>
      'تعذّر التقاط الصورة. يرجى المحاولة مرة أخرى.';

  @override
  String get cameraUnavailable => 'الكاميرا غير متاحة';

  @override
  String get notSignedIn => 'يجب تسجيل الدخول لإنشاء مهمة';

  @override
  String get startJob => 'بدء المهمة';

  @override
  String get submitForApproval => 'إرسال للاعتماد';

  @override
  String get approveJob => 'اعتماد';

  @override
  String get cancelJob => 'إلغاء المهمة';

  @override
  String get keepJob => 'الاحتفاظ بالمهمة';

  @override
  String get cancelJobPrompt =>
      'لا يمكن التراجع عن إلغاء المهمة. يرجى ذكر السبب.';

  @override
  String get cancelReasonLabel => 'السبب';

  @override
  String get cancelReasonHint => 'مثال: تم الإبلاغ عنها بالخطأ';

  @override
  String get reasonRequired => 'يجب إدخال سبب';

  @override
  String get jobUpdateFailed => 'تعذّر تحديث المهمة. يرجى المحاولة مرة أخرى.';

  @override
  String get cancellationReason => 'سبب الإلغاء';

  @override
  String startedBy(String name) {
    return 'بدأها $name';
  }

  @override
  String approvedBy(String name) {
    return 'اعتمدها $name';
  }

  @override
  String cancelledBy(String name) {
    return 'ألغاها $name';
  }

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get roleSupervisor => 'مشرف';

  @override
  String get roleWorker => 'عامل';

  @override
  String get profileComingSoon => 'إعدادات الحساب قادمة قريبًا.';

  @override
  String get close => 'إغلاق';

  @override
  String get viewPhoto => 'عرض الصورة';

  @override
  String get progress => 'التقدّم';

  @override
  String get details => 'التفاصيل';

  @override
  String get created => 'أُنشئت';

  @override
  String get noJobsFoundHint => 'جرّب تصفية أخرى أو كلمة بحث مختلفة.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get nextStep => 'الخطوة التالية';

  @override
  String get endOfList => 'هذه كل المهام';

  @override
  String get yourJobs => 'مهامك';

  @override
  String get account => 'الحساب';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signOutPrompt => 'ستحتاج إلى تسجيل الدخول مرة أخرى لعرض مهامك.';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get stepJob => 'المهمة';

  @override
  String get photo => 'صورة';

  @override
  String get whatNeedsDoing => 'ما المطلوب عمله؟';

  @override
  String get whereIsIt => 'أين موقعها؟';

  @override
  String get chooseLocation => 'اختر الموقع';

  @override
  String get optional => 'اختياري';

  @override
  String get reviewJob => 'مراجعة';

  @override
  String get createJobAction => 'إنشاء المهمة';

  @override
  String get jobCreated => 'تم إنشاء المهمة';

  @override
  String stepOf(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get noJobsYet => 'لا توجد مهام بعد';

  @override
  String get noJobsYetHint => 'أنشئ أول مهمة وستظهر هنا.';

  @override
  String get noConnection => 'لا يوجد اتصال';

  @override
  String get noConnectionHint =>
      'يبدو أنك غير متصل بالإنترنت. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get noNotifications => 'لا جديد';

  @override
  String get noNotificationsHint =>
      'سنخبرك هنا عندما ينشئ أحد أفراد فريقك مهمة أو يرسلها للموافقة.';

  @override
  String get markAllRead => 'تعليم الكل كمقروء';

  @override
  String notificationJobCreated(String actor) {
    return 'أنشأ $actor مهمة جديدة';
  }

  @override
  String notificationJobSubmitted(String actor) {
    return 'أرسل $actor مهمة للموافقة';
  }
}
