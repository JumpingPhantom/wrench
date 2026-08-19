import 'package:json_annotation/json_annotation.dart';

/// Matches the zone an ISO 8601 string ends with, if it carries one at all:
/// `Z`, `+03:00`, `-0500`.
final _zoneSuffix = RegExp(r'(Z|z|[+-]\d{2}:?\d{2})$');

/// Every instant crosses the wire as UTC, carrying the zone that says so.
///
/// `DateTime.now()` is a local time, and `toIso8601String()` writes a local one
/// without any zone at all — Postgres then reads that bare wall clock in the
/// server's own timezone, which recorded a job filed at 19:50 in Riyadh as
/// 19:50 UTC: three hours into the future.
String instantToJson(DateTime value) => value.toUtc().toIso8601String();

/// Reads a stored timestamp back as the instant it names.
///
/// The zone has to be looked for in the string rather than in the parsed
/// result: [DateTime.parse] resolves both `…Z` and `…+03:00` to the right
/// instant but flags only the first as UTC, so `isUtc` cannot tell "already
/// correct" from "carried no zone at all". A string with no zone is one this
/// app wrote, and [instantToJson] writes those in UTC.
DateTime instantFromJson(String value) {
  final parsed = DateTime.parse(value);

  if (_zoneSuffix.hasMatch(value)) return parsed.toUtc();

  // No zone: the same wall clock, read as UTC instead of as this device's
  // local time.
  return DateTime.utc(
    parsed.year,
    parsed.month,
    parsed.day,
    parsed.hour,
    parsed.minute,
    parsed.second,
    parsed.millisecond,
    parsed.microsecond,
  );
}

/// [instantToJson] and [instantFromJson] as a converter, for the fields whose
/// serialisation is generated.
class UtcDateTime implements JsonConverter<DateTime, String> {
  const UtcDateTime();

  @override
  DateTime fromJson(String json) => instantFromJson(json);

  @override
  String toJson(DateTime object) => instantToJson(object);
}
