import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../res/drawable.dart';
import '../../utils/image_utils.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageUtils.setAssetsImage(
            path: Drawable.emptyDataIcon,
            width: 60,
            height: 60,
            color: secondaryExtraLightTextColor_(context)),
        SizedBox(
          height: 20,
        ),
        TitleTextView(
          text: 'empty_data_message'.tr,
          color: secondaryTextColor_(context),
        )
      ],
    );
  }
}
