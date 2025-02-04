import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otm_inventory/res/drawable.dart';

class AppLogoWidget extends StatelessWidget {
  AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        Drawable.imgLogo,
        height: 150,
        width: double.infinity,
      ),
    );
  }
}
