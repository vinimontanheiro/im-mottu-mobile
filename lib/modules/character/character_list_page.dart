import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marvel/models/character.dart';
import 'package:marvel/modules/character/character_card.dart';
import 'package:marvel/modules/character/character_controller.dart';
import 'package:marvel/modules/menu/menu_handler.dart';
import 'package:marvel/modules/ui/circular_progress_indicator_ui.dart';
import 'package:marvel/modules/ui/loading_screen_ui.dart';
import 'package:marvel/modules/ui/scroll_bar_ui.dart';
import 'package:marvel/modules/ui/search_text_field_ui.dart';
import 'package:marvel/constants/app_colors.dart';

class CharacterListPage extends GetView<CharacterController> {
  const CharacterListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) => Scaffold(
        backgroundColor: AppColors.redTheme,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          titleSpacing: 10,
          title: Obx(
            () => SearchTextFieldUI(
              controller: controller.textEditingController,
              onChanged: controller.doSearch,
              hintText: "do_search_here".tr,
              loading: controller.fetching,
            ),
          ),
          actions: const [
            MenuHandler(),
          ],
        ),
        body: SafeArea(
          child: Obx(
            () => Visibility(
              visible: controller.items.isEmpty,
              replacement: ScrollBarUI(
                controller: controller.scrollController,
                child: RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: Obx(
                    () => ListView.separated(
                      shrinkWrap: false,
                      physics: const ClampingScrollPhysics(),
                      controller: controller.scrollController,
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      itemCount: controller.items.length,
                      itemBuilder: (context, index) {
                        Character character = controller.items[index];
                        bool loading = (index + 1) == controller.items.length;
                        return CharacterCard(
                          character: character,
                          loading: loading,
                          onTap: () async {
                            await controller.detail(character);
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ),
              child: Center(
                child: Obx(
                  () => Visibility(
                    visible: !controller.fetching,
                    replacement: const CircularProgressIndicatorUI(),
                    child: Text(
                      'no_results_found_with'.trParams(
                        {
                          "name": controller.searchText,
                        },
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.whiteTheme,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      onLoading: const LoadingScreenUI(),
    );
  }
}
