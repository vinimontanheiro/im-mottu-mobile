import 'package:get/get.dart';
import 'package:marvel/constants/app_method_channel.dart';
import 'package:marvel/services/logger.dart';

class NetworkConnectivity extends GetxController {
  final Rx<bool> _connected = true.obs;

  @override
  void onInit() {
    listen();
    super.onInit();
  }

  static NetworkConnectivity get instance => Get.find<NetworkConnectivity>();

  bool get connected => _connected.value;

  set connected(bool value) {
    _connected.value = value;
    _connected.refresh();
  }

  void listen() async {
    try {
      AppMethodChannel.mottuMarvelEventChannel
          .receiveBroadcastStream()
          .listen((dynamic isConnected) {
        connected = isConnected ?? false;
      });
    } catch (e) {
      Logger.info(e);
    }
  }
}
