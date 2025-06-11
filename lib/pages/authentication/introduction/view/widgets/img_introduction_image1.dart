import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/image_utils.dart';

class ImgIntroductionImage1 extends StatelessWidget {
  ImgIntroductionImage1({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageUtils.setSvgAssetsImage(
        path: Drawable.imgSplashCenterImage2, width: 320, height: 320);
  }
}
