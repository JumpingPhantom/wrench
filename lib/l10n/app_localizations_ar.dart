// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'رنج';

  @override
  String get home => 'الرئيسية';

  @override
  String get jobs => 'المهام';

  @override
  String get analytics => 'التحليلات';

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
}
