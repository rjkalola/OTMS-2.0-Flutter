import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/trades/view/widgets/select_all_text.dart';
import 'package:belcka/pages/trades/controller/trades_controller.dart';
import 'package:belcka/pages/trades/view/widgets/company_trade_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/utils/app_utils.dart';
class CompanyTradesScreen extends StatefulWidget {
  const CompanyTradesScreen({super.key});

  @override
  State<CompanyTradesScreen> createState() => _CompanyTradesScreenState();
}

class _CompanyTradesScreenState extends State<CompanyTradesScreen> {
  final controller = Get.put(TradesController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(() => Container(
        color: backgroundColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'trades'.tr,
              isCenterTitle: false,
              isBack: true,
               widgets: actionButtons(),
              onBackPressed: () {
                controller.onBackPress();
              },
            ),
            body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                  onPressed: () {
                    controller.isInternetNotAvailable.value = false;
                    // controller.getCompanyDetailsApi();
                  },
                )
                    : Visibility(
                  visible: controller.isMainViewVisible.value,
                  child: Column(
                    children: [
                      Divider(),
                      SelectAllText(),
                      CompanyTradeList()
                    ],
                  ),
                )),
          ),
        ),
      ),),
    );
  }

  /*
  List<Widget>? actionButtons() {
    print("controller.isDataUpdated.value:" +
        controller.isDataUpdated.value.toString());
    return [
      TextButton(
        onPressed: () {
          if (controller.isDataUpdated.value) {
            controller.changeCompanyBulkTradeStatusApi();
          }
        },
        child: PrimaryTextView(
          text: 'save'.tr,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: controller.isDataUpdated.value
              ? defaultAccentColor_(context)
              : defaultAccentLightColor_(context),
        ),
      )
    ];
  }
  */

  List<Widget>? actionButtons() {
    return [
      SizedBox(width: 10),
      Visibility(
        visible: true,
        child: IconButton(
          icon: Icon(Icons.more_vert_outlined),
          onPressed: () {
            controller.showMenuItemsDialog(Get.context!);
          },
        ),
      ),
    ];
  }
}
