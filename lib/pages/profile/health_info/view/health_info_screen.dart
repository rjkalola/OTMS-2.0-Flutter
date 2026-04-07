import 'package:belcka/pages/profile/health_info/controller/health_info_controller.dart';
import 'package:belcka/pages/profile/health_info/view/widgets/health_info_emergency_section.dart';
import 'package:belcka/pages/profile/health_info/view/widgets/health_info_metrics_section.dart';
import 'package:belcka/pages/profile/health_info/view/widgets/health_info_questions_section.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HealthInfoScreen extends StatefulWidget {
  const HealthInfoScreen({super.key});

  @override
  State<HealthInfoScreen> createState() => _HealthInfoScreenState();
}

class _HealthInfoScreenState extends State<HealthInfoScreen> {
  final controller = Get.put(HealthInfoController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'health_info'.tr,
                isCenterTitle: false,
                isBack: true,
                bgColor: dashBoardBgColor_(context),
              ),
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                onPanDown: (_) => FocusScope.of(context).unfocus(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () => controller.retryFetch(),
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          physics: const BouncingScrollPhysics(),
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HealthInfoEmergencySection(),
                                HealthInfoMetricsSection(),
                                HealthInfoQuestionsSection(),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              bottomNavigationBar: SafeArea(
                child: Visibility(
                  visible: controller.isMainViewVisible.value &&
                      !controller.isInternetNotAvailable.value,
                  child: PrimaryButton(
                    margin: const EdgeInsets.fromLTRB(14, 18, 14, 16),
                    buttonText: 'save'.tr,
                    color: defaultAccentColor_(context),
                    onPressed: controller.onSave,
                    fontWeight: FontWeight.w400,
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
