import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';

class AppLogoWidget extends StatelessWidget {
  AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageUtils.setAssetsImage(
        path: Drawable.imgHeaderLogo, width: 150, height: 60);
  }
}
