import 'package:get/get.dart';
import 'package:marvel/modules/character/character_controller.dart';
import 'package:marvel/modules/character/character_detail_controller.dart';

class CharacterDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CharacterDetailController>(() => CharacterDetailController());
    Get.lazyPut<CharacterController>(() => CharacterController());

  }
}
