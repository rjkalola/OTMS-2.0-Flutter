import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/payment_documents/expire_soon_certificates/controller/expire_soon_certificates_controller.dart';
import 'package:belcka/pages/payment_documents/expire_soon_certificates/view/widgets/expire_soon_info_footer.dart';
import 'package:belcka/pages/payment_documents/expire_soon_certificates/view/widgets/expire_soon_sections_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ExpireSoonCertificatesScreen extends StatefulWidget {
  const ExpireSoonCertificatesScreen({super.key});

  @override
  State<ExpireSoonCertificatesScreen> createState() =>
      _ExpireSoonCertificatesScreenState();
}

class _ExpireSoonCertificatesScreenState extends State<ExpireSoonCertificatesScreen>
    implements DateFilterListener {
  final controller = Get.put(ExpireSoonCertificatesController());

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
                title: 'expired_soon'.tr,
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
                          controller.loadExpireSoonCertificates(true);
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            // const SizedBox(height: 16),
                            // DateFilterOptionsHorizontalList(
                            //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            //   startDate: controller.startDate,
                            //   endDate: controller.endDate,
                            //   listener: this,
                            //   selectedPosition:
                            //       controller.selectedDateFilterIndex,
                            // ),
                            const SizedBox(height: 10),
                            Expanded(child: ExpireSoonSectionsList()),
                            const ExpireSoonInfoFooter(),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onSelectDateFilter(
    int filterIndex,
    String filter,
    String startDate,
    String endDate,
    String dialogIdentifier,
  ) {
    controller.isResetEnable.value = true;
    controller.startDate = startDate;
    controller.endDate = endDate;
    if (StringHelper.isEmptyString(startDate) &&
        StringHelper.isEmptyString(endDate)) {
      controller.clearFilter();
      return;
    }
    controller.loadExpireSoonCertificates(true);
  }
}
