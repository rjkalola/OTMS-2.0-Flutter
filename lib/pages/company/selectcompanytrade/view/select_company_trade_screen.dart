import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/company/selectcompanytrade/controller/select_company_trade_controller.dart';
import 'package:otm_inventory/pages/company/selectcompanytrade/view/widgets/company_logo_view.dart';
import 'package:otm_inventory/pages/company/selectcompanytrade/view/widgets/company_note_text.dart';
import 'package:otm_inventory/pages/company/selectcompanytrade/view/widgets/join_company_button.dart';
import 'package:otm_inventory/pages/company/selectcompanytrade/view/widgets/select_trade_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class SelectCompanyTradeScreen extends StatefulWidget {
  const SelectCompanyTradeScreen({super.key});

  @override
  State<SelectCompanyTradeScreen> createState() =>
      _SelectCompanyTradeScreenState();
}

class _SelectCompanyTradeScreenState extends State<SelectCompanyTradeScreen> {
  final controller = Get.put(SelectCompanyTradeController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: ''.tr,
            isCenterTitle: false,
            isBack: true,
          ),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? const NoInternetWidget()
                    : Column(
                        children: [
                          Divider(),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                CompanyLogoView(),
                                CompanyNoteText(),
                                SelectTradeView()
                              ],
                            ),
                          ),
                          JoinCompanyButton()
                        ],
                      ));
          }),
        ),
      ),
    );
  }
}
