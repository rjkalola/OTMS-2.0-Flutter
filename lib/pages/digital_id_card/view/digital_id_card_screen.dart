import 'package:belcka/pages/digital_id_card/controller/digital_id_card_controller.dart';
import 'package:belcka/pages/manageattachment/controller/download_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/downloading_widget.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DigitalIdCardScreen extends StatefulWidget {
  const DigitalIdCardScreen({super.key});

  @override
  State<DigitalIdCardScreen> createState() => _DigitalIdCardScreenState();
}

class _DigitalIdCardScreenState extends State<DigitalIdCardScreen> {
  final controller = Get.put(DigitalIdCardController());
  final downloadController = Get.put(DownloadController());

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // No longer wrapped in Obx
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: 'Digital Id Card',
        isBack: true,
        widgets: actionButtons(),
      ),
      body: Stack(
        children: [

          Obx(() => _buildPdfContent()),

          Obx(() => controller.isLoading.value
              ? const Center(child: CustomProgressbar())
              : const SizedBox.shrink()),

          Obx(() => downloadController.isDownloading.value
              ? DownloadLoader(progress: downloadController.progress.value)
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildPdfContent() {
    final pdfUrl = controller.digitalIdCardInfo.value.pdfDownloadUrl;
    if (pdfUrl == null || pdfUrl.isEmpty) {
      return const SizedBox.shrink();
    }
    return SfPdfViewer.network(
      pdfUrl,
      onDocumentLoaded: (details) {
        controller.isLoading.value = false;
        controller.isMainViewVisible.value = true;
      },
      onDocumentLoadFailed: (details) {
        controller.isLoading.value = false;
        controller.isMainViewVisible.value = false;
        print("PDF Load Failed: ${details.description}");
      },
      canShowPageLoadingIndicator: false,
    );
  }

  List<Widget>? actionButtons() {
    return [
      Obx(() => Visibility(
        visible: controller.isMainViewVisible.value,
        child: TextViewWithContainer(
            width: 120,
            height: 33,
            borderRadius: 15,
            fontWeight: FontWeight.w500,
            text: "Save PDF",
            fontColor: Colors.white,
            boxColor: defaultAccentColor_(context),
            alignment: Alignment.center,
            onTap: () {
              if (!StringHelper.isEmptyString(
                  controller.digitalIdCardInfo.value.pdfDownloadUrl)) {
                downloadController.isDownloading.value
                    ? null
                    : downloadController.downloadFile(
                    controller.digitalIdCardInfo.value.pdfDownloadUrl ?? "",
                    "${controller.digitalIdCardInfo.value.name ?? ""}'s ID Card.pdf",
                    downloadSuccessMessage:
                    'digital_id_card_downloaded'.tr);
              }
            }),
      )),
      const SizedBox(width: 12),
    ];
  }

}