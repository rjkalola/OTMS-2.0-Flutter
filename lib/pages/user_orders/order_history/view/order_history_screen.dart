import 'package:belcka/pages/user_orders/order_history/controller/order_history_controller.dart';
import 'package:belcka/pages/user_orders/order_history/view/widgets/order_history_filter_tabs.dart';
import 'package:belcka/pages/user_orders/order_history/view/widgets/order_history_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
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
              title: 'history'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              widgets: actionButtons(),
              isSearching: controller.isSearchEnable.value,
              searchController: controller.searchController,
              onValueChange: (value) {
                controller.searchItem(value);
              },
              autoFocus: true,
              isClearVisible: false.obs,
              onBackPressed: (){
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
                },
              )
                  : controller.isMainViewVisible.value
                  ? Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderHistoryFilterTabs(),
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
      InkWell(
        onTap: () {
          controller.isSearchEnable.toggle();
          if (!controller.isSearchEnable.value) {
            controller.clearSearch();
          }
        },
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Obx(() => controller.isSearchEnable.value
              ? Icon(
            Icons.close,
          )
              : ImageUtils.setSvgAssetsImage(
            path: Drawable.searchIcon,
            width: 24,
            height: 24,
          )),
        ),
      ),
      SizedBox(
        width: 10,
      ),
    ];
  }
}
