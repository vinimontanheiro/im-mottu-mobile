import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marvel/constants/app_colors.dart';
import 'package:marvel/models/character.dart';
import 'package:marvel/modules/ui/circular_progress_indicator_ui.dart';
import 'package:marvel/services/dimensions.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final void Function() onTap;
  final bool loading;
  final double width;
  final bool showInfo;
  final bool isThumbnail;

  const CharacterCard({
    super.key,
    required this.onTap,
    this.loading = false,
    required this.character,
    this.width = 100,
    this.isThumbnail = false,
    this.showInfo = true,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: FadeIn(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onTap: onTap,
                    child: CachedNetworkImage(
                      width: Dimensions.widthOf(context, width),
                      height: isThumbnail
                          ? Dimensions.widthOf(context, width)
                          : null,
                      imageUrl: character.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Visibility(
                  visible: loading,
                  child: const SizedBox(
                    height: 15,
                  ),
                ),
                Visibility(
                  visible: loading,
                  child: Center(
                    child: CircularProgressIndicatorUI(
                      color: Colors.amber.shade600,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Visibility(
            visible: showInfo,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(100),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1.5,
                  color: Colors.grey,
                ),
              ),
              child: Text(
                character.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteTheme,
                  shadows: [
                    Shadow(
                      offset: Offset(0.3, 0.3),
                      blurRadius: 0.2,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
