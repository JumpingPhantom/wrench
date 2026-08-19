import 'package:flutter_riverpod/flutter_riverpod.dart';

/// How often the clock moves for the widgets that read it.
///
/// Half a minute, so the smallest unit anything renders — a minute — is never
/// more than one tick stale, without waking the tree more than twice a minute.
const clockTick = Duration(seconds: 30);

/// The current time, re-read on every [clockTick].
///
/// A relative time is only true for as long as it took to build; without a
/// clock of its own a list left open keeps saying "Just now" until something
/// else happens to rebuild it. `autoDispose` keeps the timer honest: it runs
/// only while something is on screen watching it.
final nowProvider = StreamProvider.autoDispose<DateTime>((ref) {
  return Stream.periodic(clockTick, (_) => DateTime.now());
});
