import 'package:belcka/pages/payment_documents/certificate_details/controller/certificate_details_controller.dart';
import 'package:belcka/pages/payment_documents/certificate_details/view/widgets/certificate_details_actions.dart';
import 'package:belcka/pages/payment_documents/certificate_details/view/widgets/certificate_details_header_card.dart';
import 'package:belcka/pages/payment_documents/certificate_details/view/widgets/certificate_details_preview.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CertificateDetailsScreen extends StatefulWidget {
  const CertificateDetailsScreen({super.key});

  @override
  State<CertificateDetailsScreen> createState() =>
      _CertificateDetailsScreenState();
}

class _CertificateDetailsScreenState extends State<CertificateDetailsScreen> {
  final controller = Get.put(CertificateDetailsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop || result != null) return;
          controller.onBackPress();
        },
        child: Container(
          color: backgroundColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'document_details'.tr,
                isCenterTitle: false,
                isBack: true,
                onBackPressed: controller.onBackPress,
                bgColor: backgroundColor_(context),
                elevation: 5,
                shadowColor: shadowColor_(context).withValues(alpha: 0.28),
                surfaceTintColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                widgets: const [],
              ),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.loadCertificateDetail(true);
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CertificateDetailsHeaderCard(
                                info: controller.certificateInfo.value,
                                iconColorHex: controller.iconColorHex,
                              ),
                              CertificateDetailsPreview(
                                fileUrl:
                                    controller.certificateInfo.value.fileUrl,
                                onTap: controller.onViewDocument,
                              ),
                              CertificateDetailsActions(),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
