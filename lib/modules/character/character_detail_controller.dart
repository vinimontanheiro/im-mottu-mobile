import 'package:get/get.dart';
import 'package:marvel/models/character.dart';
import 'package:marvel/models/rx_list.dart';
import 'package:marvel/models/serie.dart';
import 'package:marvel/services/api/character_service_api.dart';
import 'package:marvel/services/api/serie_service_api.dart';
import 'package:marvel/services/logger.dart';

class CharacterDetailController extends GetxController {
  final SerieServiceAPI serieServiceAPI = SerieServiceAPI();
  final CharacterServiceAPI characterServiceAPI = CharacterServiceAPI();
  final RxListObject<Serie> _series = RxListObject<Serie>([]);
  final RxListObject<Character> _relatedCharacters =
      RxListObject<Character>([]);

  @override
  void onInit() async {
    int? characterId = Get.arguments!;
    await load(characterId);
    super.onInit();
  }

  List<Serie> get series => _series.value;

  bool get seriesLoading => _series.loading;

  List<Character> get relatedCharacters => _relatedCharacters.value;

  bool get relatedCharactersLoading => _relatedCharacters.loading;

  Future<void> handleSeries(int characterId) async {
    try {
      _series.loading = true;
      _relatedCharacters.loading = true;
      List<Serie> seriesList = await serieServiceAPI.list(characterId);
      _series.renew(seriesList);
      _series.refresh();
      _series.loading = false;
    } catch (e) {
      Logger.error(e);
    }
  }

  Future<void> handleRelatedCharacters() async {
    try {
      if (series.isNotEmpty) {
        _relatedCharacters.loading = true;
        List<int> ids = series
            .map(
              (s) => s.id,
            )
            .toList();
        List<Character> relaltedCharactersList =
            await serieServiceAPI.listRelatedCharactesBySeries(ids);
        _relatedCharacters.renew(relaltedCharactersList);
        _relatedCharacters.refresh();
        _relatedCharacters.loading = false;
      }
    } catch (e) {
      Logger.error(e);
    }
  }

  Future<void> load(int? characterId) async {
    try {
      if (characterId != null) {
        await handleSeries(characterId);
        await handleRelatedCharacters();
      }
    } catch (e) {
      Logger.error(e);
    }
  }
}
