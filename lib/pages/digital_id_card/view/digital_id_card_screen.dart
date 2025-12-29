import 'package:belcka/pages/digital_id_card/controller/digital_id_card_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/shapes/circle_widget.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DigitalIdCardScreen extends StatelessWidget {
  DigitalIdCardScreen({super.key});

  final controller = Get.put(DigitalIdCardController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'Digital Id Card',
              isBack: true,
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              progressIndicator: const CustomProgressbar(),
              child: controller.webViewController == null
                  ? const SizedBox()
                  : WebViewWidget(
                controller: controller.webViewController!,
              ),
            ),
          )
    );
  }
}


