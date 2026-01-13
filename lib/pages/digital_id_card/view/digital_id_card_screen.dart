import 'package:belcka/pages/digital_id_card/controller/digital_id_card_controller.dart';
import 'package:belcka/pages/manageattachment/controller/download_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/downloading_widget.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DigitalIdCardScreen extends StatelessWidget {
  DigitalIdCardScreen({super.key});

  final controller = Get.put(DigitalIdCardController());
  final downloadController = Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'Digital Id Card',
            isBack: true,
            widgets: actionButtons(),
          ),
          body: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            progressIndicator: const CustomProgressbar(),
            child: controller.webViewController == null
                ? const SizedBox()
                : Stack(
                    children: [
                      WebViewWidget(
                        controller: controller.webViewController!,
                      ),
                      downloadController.isDownloading.value
                          ? DownloadLoader(
                              progress: downloadController.progress.value)
                          : Container()
                    ],
                  ),
          ),
        ));
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: controller.isMainViewVisible.value,
        child: TextViewWithContainer(
            width: 100,
            height: 33,
            borderRadius: 15,
            fontWeight: FontWeight.w500,
            text: "Save PDF",
            fontColor: Colors.white,
            boxColor: defaultAccentColor_(Get.context!),
            alignment: Alignment.center,
            onTap: () {
              if (!StringHelper.isEmptyString(
                  controller.digitalIdCardInfo.value.pdfDownloadUrl)) {
                downloadController.isDownloading.value
                    ? null
                    : downloadController.downloadPdf(
                        controller.digitalIdCardInfo.value.pdfDownloadUrl ?? "",
                        "${controller.digitalIdCardInfo.value.name ?? ""}'s ID Card.pdf",
                        downloadSuccessMessage:
                            'digital_id_card_downloaded'.tr);
              }
            }),
      ),
      SizedBox(
        width: 12,
      )
    ];
  }
}
