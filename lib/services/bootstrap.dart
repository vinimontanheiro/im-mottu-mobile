import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marvel/constants/app_images.dart';
import 'package:marvel/firebase_options.dart';
import 'package:marvel/services/network_connectivity.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class Bootstrap {
  static precacheAppImages(BuildContext context) async {
    // ignore: use_build_context_synchronously
    await precacheImage(const AssetImage(AppImages.loading), context);
    // ignore: use_build_context_synchronously
    await precacheImage(const AssetImage(AppImages.marvel), context);
    // ignore: use_build_context_synchronously
    await precacheImage(const AssetImage(AppImages.marvelLogo), context);
    // ignore: use_build_context_synchronously
    await precacheImage(const AssetImage(AppImages.marvelLogoGif), context);
  }

  static resources(BuildContext context) {
    Bootstrap.precacheAppImages(context);
  }

  static setupDependencies() {
    Get.put<NetworkConnectivity>(NetworkConnectivity(), permanent: true);
  }

  static setupCrashlytics() {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
        fatal: true,
      );
    }).sendPort);
  }

  static Future<FirebaseApp> initialize() async {
    Bootstrap.setupDependencies();
    FirebaseApp app = await Firebase.initializeApp(
      name: 'mottumarvel',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    setupCrashlytics();
    return app;
  }
}
