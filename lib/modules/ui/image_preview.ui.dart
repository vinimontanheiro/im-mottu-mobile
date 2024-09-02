import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marvel/constants/app_colors.dart';
import 'package:marvel/services/dimensions.dart';

class ImagePreviewUI extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double? height;

  const ImagePreviewUI({
    super.key,
    required this.imageUrl,
    this.width = 100.0,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.redTheme,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
      body: Center(
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: CachedNetworkImage(
            width: Dimensions.widthOf(context, width),
            height: height,
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
