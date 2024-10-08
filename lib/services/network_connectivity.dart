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

  Future<bool> listen() async {
    try {
      AppMethodChannel.mottuMarvelEventChannel
          .receiveBroadcastStream()
          .listen((dynamic isConnected) {
        connected = isConnected ?? false;
      });
      return true;
    } catch (e) {
      Logger.error(e);
      return Future.error(e);
    }
  }
}
