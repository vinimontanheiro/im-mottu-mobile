import 'package:flutter/services.dart';

class AppMethodChannel {
  static const networkConnectivity = "network_connectivity";
  static const mottuMarvelEventChannel =
      EventChannel('com.mottu.marvel/$networkConnectivity');
}
