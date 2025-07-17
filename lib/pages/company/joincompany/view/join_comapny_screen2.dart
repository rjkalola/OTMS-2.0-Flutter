import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/company/joincompany/controller/join_company_controller.dart';
import 'package:otm_inventory/pages/company/joincompany/view/widgets/add_company_code_view.dart';
import 'package:otm_inventory/pages/company/joincompany/view/widgets/do_ite_later_text.dart';
import 'package:otm_inventory/pages/company/joincompany/view/widgets/select_company_view.dart';
import 'package:otm_inventory/pages/company/joincompany/view/widgets/text_or.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';
import 'package:otm_inventory/utils/app_utils.dart';
class JoinCompanyScreen extends StatefulWidget {
  const JoinCompanyScreen({super.key});

  @override
  State<JoinCompanyScreen> createState() => _JoinCompanyScreenState();
}

class _JoinCompanyScreenState extends State<JoinCompanyScreen> {
  final controller = Get.put(JoinCompanyController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'join_company'.tr,
            isCenterTitle: false,
            isBack: false,
          ),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? const NoInternetWidget()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            SelectCompanyView(),
                            TextOr(),
                            AddCompanyCode(),
                            TextOr(),
                            // JoinCompanyViaQrCode(),
                            TextOr(),
                            // RegisterANewCompanyView(),
                            DoItLater()
                          ],
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
