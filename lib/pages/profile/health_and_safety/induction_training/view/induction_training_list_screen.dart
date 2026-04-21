import 'package:belcka/pages/profile/health_and_safety/induction_training/controller/induction_training_list_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/induction_training/view/induction_training_list_widget.dart';
import 'package:belcka/pages/user_orders/widgets/empty_state_view.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class InductionTrainingListScreen extends StatefulWidget {
  const InductionTrainingListScreen({super.key});

  @override
  State<InductionTrainingListScreen> createState() => _InductionTrainingListScreenState();
}

class _InductionTrainingListScreenState extends State<InductionTrainingListScreen> {
  final controller = Get.put(InductionTrainingListController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
          () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              appBar: OrdersBaseAppBar(
                appBar: AppBar(),
                title: 'induction_and_training'.tr,
                isCenterTitle: false,
                isBack: true,
                bgColor: backgroundColor_(context),
                onBackPressed: () {
                  controller.onBackPress();
                },
              ),
              backgroundColor: dashBoardBgColor_(context),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                  onPressed: () {
                    controller.isInternetNotAvailable.value = false;
                  },
                )
                    : controller.isMainViewVisible.value
                    ? (controller.inductionTrainingList.isNotEmpty) ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: InductionTrainingListWidget(),
                ) : EmptyStateView(
                  title: 'no_data_found'.tr,
                  message:"",
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }

}