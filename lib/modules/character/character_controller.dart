import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:marvel/models/character.dart';
import 'package:marvel/modules/character/character_detail_page.dart';
import 'package:marvel/modules/search/search_generic_controller.dart';
import 'package:marvel/services/api/marvel_characters_service_api.dart';
import 'package:marvel/services/logger.dart';
import 'package:marvel/services/network_connectivity.dart';

class CharacterController extends SearchGenericController<Character> {
  final MarvelCharactersServiceAPI marvelCharactersServiceAPI =
      MarvelCharactersServiceAPI();

  @override
  int get limit => 20;

  @override
  void onInit() async {
    FlutterNativeSplash.remove();
    change(false, status: RxStatus.loading());
    await checkDataCache();
    super.onInit();
  }

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
      if (NetworkConnectivity.instance.connected) {
        fetching = true;
        List<Character> characters = (await marvelCharactersServiceAPI.list(
          nameStartsWith: searchText,
          offset: items.length,
          limit: limit,
        ))
            .cast<Character>();
        updateItems(offset, characters);
        change(true, status: RxStatus.success());
        fetching = false;
      }
    } catch (e) {
      Logger.error(e);
    }
  }

  Future<void> detail(Character character) async {
    try {
      // await marvelCharactersServiceAPI.get(character.id);
      await Get.to(
        () => CharacterDetailPage(character: character),
        fullscreenDialog: true,
        transition: Transition.downToUp,
      );
    } catch (e) {
      Logger.error(e);
    }
  }
}
