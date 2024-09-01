import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marvel/constants/app_colors.dart';
import 'package:marvel/services/dimensions.dart';
import 'package:marvel/services/network_connectivity.dart';

class App extends StatelessWidget {
  final Widget child;

  const App({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => SafeArea(
            top: false,
            bottom: true,
            child: Stack(
              fit: StackFit.expand,
              children: [
                child,
                Positioned.fill(
                  top: Dimensions.top(context),
                  child: Obx(
                    () => !NetworkConnectivity.instance.connected
                        ? Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Pulse(
                              infinite: true,
                              child: const Icon(
                                Icons.wifi_off_rounded,
                                color: AppColors.whiteTheme,
                                size: 30,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
