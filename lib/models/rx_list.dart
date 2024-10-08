import 'package:get/get.dart';
import 'package:marvel/services/logger.dart';

class RxListObject<T> extends Rx<List<T>> {
  RxListObject(
    super.initial,
  );

  final Rx<bool> _loading = false.obs;

  bool get loading => _loading.value;

  set loading(bool value) {
    _loading.value = value;
    _loading.refresh();
  }

  void push(dynamic item) {
    try {
      if (value.where((dynamic itemRef) => itemRef.uid == item.uid).isEmpty) {
        value.toList().add(item);
        refresh();
      }
    } catch (e) {
      Logger.error(e);
    }
  }

  void pop(dynamic item) {
    try {
      if (value
          .where((dynamic itemRef) => itemRef.uid == item.uid)
          .isNotEmpty) {
        value
            .toList()
            .removeWhere((dynamic itemParam) => itemParam.uid == item.uid);
        refresh();
      }
    } catch (e) {
      Logger.error(e);
    }
  }

  void updateItem(dynamic item) {
    try {
      if (value
          .where((dynamic itemRef) => itemRef.uid == item.uid)
          .isNotEmpty) {
        int index = value.indexWhere(
          (dynamic itemParam) => itemParam.uid == item.uid,
        );
        value[index] = item;
        refresh();
      }
    } catch (e) {
      Logger.error(e);
    }
  }

  void append(List<T> items) {
    value = <T>{...value, ...items}.toList();
    refresh();
  }

  void renew(List<T> items) {
    value = items;
    refresh();
  }

  void clear() {
    value.clear();
    refresh();
  }

  void toggle(dynamic item) {
    try {
      if (value
          .where((dynamic itemRef) => itemRef.uid == item.uid)
          .isNotEmpty) {
        pop(item);
      } else {
        push(item);
      }
    } catch (e) {
      Logger.error(e);
    }
  }
}
