import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marvel/constants/app_images.dart';
import 'package:marvel/services/network_connectivity.dart';

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

  static Future<void> initialize() async {
    Bootstrap.setupDependencies();
  }
}
