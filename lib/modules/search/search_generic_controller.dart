import 'package:get/get.dart';
import 'package:marvel/mixins/cached_data.dart';
import 'package:marvel/mixins/infinite_scroll_mixin_controller.dart';

class SearchGenericController<T> extends GetxController
    with InfiniteScrollMixinController<T>, StateMixin<bool>, CachedData {
  static SearchGenericController get instance =>
      Get.find<SearchGenericController>();
}
