import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class Logger {
  static void error(
    dynamic error, {
    StackTrace? stackTrace,
    String reason = 'a non-fatal error',
  }) async {
    try {
      await FirebaseCrashlytics.instance
          .recordError(error, stackTrace, reason: reason);
    } catch (e) {
      debugPrint(error.toString());
    }
  }
}
