import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/app/app.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init();
  await dotenv.load();

  await Supabase.initialize(
    url: _requireEnv('SUPABASE_URL'),
    publishableKey: _requireEnv('SUPABASE_PUBLISHABLE_KEY'),
  );

  runApp(const ProviderScope(child: App()));
}

/// Reads a required entry from `.env`, failing with the missing key's name.
///
/// Without this a misspelled or absent key surfaces as a bare null-check error
/// inside [Supabase.initialize], which says nothing about what to fix.
String _requireEnv(String key) {
  final value = dotenv.env[key];

  if (value == null || value.isEmpty) {
    ConfigurationException(message: "Missing '$key' in .env").throwSelf();
  }

  return value;
}
