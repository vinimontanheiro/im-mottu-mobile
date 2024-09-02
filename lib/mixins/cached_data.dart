import 'dart:convert';
import 'dart:core';
import 'package:get/get.dart';
import 'package:marvel/constants/app_keys.dart';
import 'package:marvel/services/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin CachedData on GetxController {
  Future<void> put(List<Map<String, dynamic>> data) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String encodedData = json.encode(data);
      await preferences.setString(AppKeys.cachedData, encodedData);
    } catch (e) {
      Logger.error(e);
      return Future.error(e);
    }
  }

  Future<List<Map<String, dynamic>>> retrieve() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? encodedData = preferences.getString(AppKeys.cachedData);
      if (encodedData != null) {
        return json.decode(encodedData);
      }
      return [];
    } catch (e) {
      Logger.error(e);
      return Future.error(e);
    }
  }

  Future<void> clear() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
    } catch (e) {
      Logger.error(e);
      return Future.error(e);
    }
  }
}
