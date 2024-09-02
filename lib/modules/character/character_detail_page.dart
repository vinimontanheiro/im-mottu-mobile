import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marvel/models/character.dart';
import 'package:marvel/models/serie.dart';
import 'package:marvel/modules/character/character_card.dart';
import 'package:marvel/modules/character/character_controller.dart';
import 'package:marvel/modules/character/character_detail_controller.dart';
import 'package:marvel/modules/ui/circular_progress_indicator_ui.dart';
import 'package:marvel/modules/ui/divider_ui.dart';
import 'package:marvel/modules/ui/scaffold_extend_body_ui.dart';
import 'package:marvel/constants/app_colors.dart';
import 'package:marvel/services/dimensions.dart';

class CharacterDetailPage extends GetView<CharacterDetailController> {
  final Character character;

  const CharacterDetailPage({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldExtendBodyUI(
      backgroundColor: AppColors.redTheme,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        excludeHeaderSemantics: true,
        elevation: 0,
        leading: IconButton(
          iconSize: 35,
          icon: const Icon(
            Icons.keyboard_arrow_down_sharp,
            size: 35,
            color: Colors.amber,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              width: Dimensions.widthOf(context, 100),
              imageUrl: character.imageUrl,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              leading: const Icon(
                Icons.info_outline,
                color: AppColors.whiteTheme,
              ),
              title: Text(
                character.name,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.whiteTheme,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Visibility(
                visible: character.description.isNotEmpty,
                child: Text(
                  character.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            Accordion(
              headerBorderColor: AppColors.whiteTheme,
              headerBorderColorOpened: AppColors.whiteTheme,
              headerBorderWidth: 0,
              headerBackgroundColorOpened: Colors.transparent,
              contentBackgroundColor: AppColors.redTheme,
              contentBorderColor: AppColors.whiteTheme,
              headerBackgroundColor: Colors.transparent,
              contentBorderWidth: 0,
              contentHorizontalPadding: 6,
              scaleWhenAnimating: true,
              openAndCloseAnimation: true,
              headerPadding:
                  const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              sectionOpeningHapticFeedback: SectionHapticFeedback.light,
              sectionClosingHapticFeedback: SectionHapticFeedback.light,
              disableScrolling: true,
              children: [
                AccordionSection(
                  isOpen: false,
                  header: const DividerUI(
                    color: AppColors.overlayWhite,
                  ),
                  rightIcon: const SizedBox(),
                  content: const SizedBox(),
                  headerPadding: EdgeInsets.zero,
                ),
                AccordionSection(
                  isOpen: false,
                  contentVerticalPadding: 8,
                  leftIcon:
                      const Icon(Icons.stream_outlined, color: Colors.white),
                  rightIcon: Obx(
                    () => Visibility(
                      visible: controller.seriesLoading,
                      replacement: const Icon(Icons.keyboard_arrow_up_sharp,
                          size: 28, color: AppColors.whiteTheme),
                      child: const CircularProgressIndicatorUI(
                        width: 15,
                        height: 15,
                      ),
                    ),
                  ),
                  header: Text(
                    'series'.tr.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.whiteTheme,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SizedBox(
                    width: Dimensions.widthOf(context, 100),
                    height: Dimensions.heightOf(context, 86),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.series.length,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        Serie serie = controller.series[index];
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                onTap: () async {
                                  // await controller.detail(character);
                                },
                                child: CachedNetworkImage(
                                  width: Dimensions.widthOf(context, 80),
                                  height: Dimensions.heightOf(context, 70),
                                  imageUrl: serie.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              serie.title,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.whiteTheme,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 5,
                      ),
                    ),
                  ),
                ),
                AccordionSection(
                  isOpen: false,
                  header: const DividerUI(
                    color: AppColors.overlayWhite,
                  ),
                  rightIcon: const SizedBox(),
                  content: const SizedBox(),
                  headerPadding: EdgeInsets.zero,
                ),
                AccordionSection(
                  isOpen: !controller.relatedCharactersLoading,
                  contentVerticalPadding: 8,
                  leftIcon: const Icon(Icons.groups, color: Colors.white),
                  rightIcon: Obx(
                    () => Visibility(
                      visible: controller.relatedCharactersLoading,
                      replacement: const Icon(Icons.keyboard_arrow_up_sharp,
                          size: 28, color: AppColors.whiteTheme),
                      child: const CircularProgressIndicatorUI(
                        width: 15,
                        height: 15,
                      ),
                    ),
                  ),
                  header: Text(
                    'related_characters'.tr.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.whiteTheme,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Obx(
                    () => Visibility(
                      visible: !controller.relatedCharactersLoading,
                      child: SizedBox(
                        width: Dimensions.widthOf(context, 100),
                        child: Obx(
                          () => Wrap(
                            direction: Axis.horizontal,
                            runSpacing: 5.0,
                            spacing: 5,
                            children: controller.relatedCharacters
                                .map((character) => CharacterCard(
                                      width: 12,
                                      character: character,
                                      loading: false,
                                      isThumbnail: true,
                                      showInfo: false,
                                      onTap: () async {
                                        await CharacterController.instance
                                            .deatail(
                                          character.id,
                                        );
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AccordionSection(
                  isOpen: false,
                  header: const DividerUI(
                    color: AppColors.overlayWhite,
                  ),
                  rightIcon: const SizedBox(),
                  content: const SizedBox(),
                  headerPadding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
