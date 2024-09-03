import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:marvel/models/character.dart';
import 'package:marvel/modules/character/character_detail_bindings.dart';
import 'package:marvel/modules/character/character_detail_page.dart';
import 'package:marvel/modules/search/search_generic_controller.dart';
import 'package:marvel/modules/ui/image_preview.ui.dart';
import 'package:marvel/services/api/character_service_api.dart';
import 'package:marvel/services/api/serie_service_api.dart';
import 'package:marvel/services/logger.dart';
import 'package:marvel/services/network_connectivity.dart';

class CharacterController extends SearchGenericController<Character> {
  final CharacterServiceAPI characterServiceAPI = CharacterServiceAPI();
  final SerieServiceAPI serieServiceAPI = SerieServiceAPI();

  @override
  void onInit() async {
    FlutterNativeSplash.remove();
    change(false, status: RxStatus.loading());
    await checkDataCache();
    super.onInit();
  }

  @override
  int get limit => 20;

  static get instance => Get.find<CharacterController>();

  Future<void> checkDataCache() async {
    try {
      if (!NetworkConnectivity.instance.connected) {
        List<Map<String, dynamic>> data = await retrieve();
        updateItems(0, Character.fromJsonList(data));
        change(true, status: RxStatus.success());
        fetching = false;
      }
    } catch (e) {
      Logger.error(e);
    }
  }

  @override
  Future<void> updateItems(int offset, List<Character> items) async {
    try {
      super.updateItems(offset, items);

      if (items.isNotEmpty) {
        await put(Character.toJsonList(items));
      }
    } catch (e) {
      Logger.error(e);
    }
  }

  @override
  Future<void> list(int offset) async {
    try {
      fetching = true;
      if (NetworkConnectivity.instance.connected) {
        List<Character> characters = (await characterServiceAPI.list(
          nameStartsWith: searchText,
          offset: items.length,
          limit: limit,
        ));
        updateItems(offset, characters);
        change(true, status: RxStatus.success());
      }
      fetching = false;
    } catch (e) {
      Logger.error(e);
    }
  }

  Future<void> detail(Character character) async {
    try {
      await Get.to(
        () => CharacterDetailPage(character: character),
        fullscreenDialog: true,
        transition: Transition.downToUp,
        arguments: character.id,
        binding: CharacterDetailBindings(),
      );
    } catch (e) {
      Logger.error(e);
    }
  }

  Future<void> preview(String imageUrl) async {
    try {
      await Get.to(
        () => ImagePreviewUI(
          imageUrl: imageUrl,
        ),
      );
    } catch (e) {
      Logger.error(e);
    }
  }
}
