import 'package:belcka/pages/user_orders/order_history/controller/order_history_controller.dart';
import 'package:belcka/pages/user_orders/order_history/view/widgets/order_history_card.dart';
import 'package:belcka/pages/user_orders/order_history/view/widgets/order_history_filter_list.dart';
import 'package:belcka/pages/user_orders/order_history/view/widgets/order_history_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class OrderHistoryScreen extends StatelessWidget {
   OrderHistoryScreen({super.key});
  final controller = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Obx(
              () => Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'History'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              widgets: actionButtons(),
              autoFocus: true,
              isClearVisible: false.obs,
            ),
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
                  ? Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderHistoryFilterList(),
                    SizedBox(height: 12),
                    OrderHistoryList()
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      IconButton(icon: Icon(Icons.search), onPressed: () {}),
    ];
  }
}