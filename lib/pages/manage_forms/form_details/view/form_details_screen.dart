import 'package:belcka/pages/manage_forms/form_details/controller/form_details_controller.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/form_fields_list.dart';
import 'package:belcka/pages/manage_forms/form_details/view/widgets/form_send_button.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FormDetailsScreen extends StatefulWidget {
  const FormDetailsScreen({super.key});

  @override
  State<FormDetailsScreen> createState() => _FormDetailsScreenState();
}

class _FormDetailsScreenState extends State<FormDetailsScreen> {
  final controller = Get.put(FormDetailsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          top: false,
          bottom: !GetPlatform.isIOS,
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.screenTitle.value,
              isCenterTitle: false,
              isBack: true,
              bgColor: dashBoardBgColor_(context),
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                      onPressed: () {
                        controller.isInternetNotAvailable.value = false;
                        controller.fetchFormDetail();
                      },
                    )
                  : Visibility(
                      visible: controller.isMainViewVisible.value,
                      child: Column(
                        children: [
                          Expanded(child: FormFieldsList()),
                          FormSendButton(),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
