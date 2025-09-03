import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/introduction/controller/introduction_controller.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/widgets/image/circular_svg_assets_image.dart';

class LanguageDropdownWidget extends StatelessWidget {
  LanguageDropdownWidget({super.key});

  final controller = Get.put(IntroductionController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Row(
          children: [
            CircularSvgAssetsImage(
              assetsPath: Drawable.flagEnglish,
              width: 20,
              height: 20,
              radiusSize: 10,
              placeHolderSize: 30,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 8,
            ),
            Text("EN",
                textAlign: TextAlign.start,
                style:  TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: Color(0xff000000),
            ),
          ]),
      onTap: () {
        // controller.showPhoneExtensionDialog();
      },
    );
  }
}
