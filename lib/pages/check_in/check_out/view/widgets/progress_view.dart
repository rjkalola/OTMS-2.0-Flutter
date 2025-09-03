import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/slider/custom_slider.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

import '../../controller/check_out_controller.dart';

class ProgressView extends StatelessWidget {
  ProgressView({super.key});

  final controller = Get.put(CheckOutController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 6, 0, 0),
            child: TitleTextView(
              text: 'progress'.tr,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CustomSlider(
                  progress: controller.progress,
                  onChanged: (newValue) {
                    if (StringHelper.isEmptyString(
                        controller.checkLogInfo.value.checkoutDateTime)) {
                      controller.progress.value =
                          newValue.roundToDouble().toInt();
                    }
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TitleTextView(
                text: "${controller.progress}%",
              )
            ],
          ),
          SizedBox(
            height: 6,
          )
        ],
      ),
    );
  }
}
