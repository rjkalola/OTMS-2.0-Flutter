import 'package:belcka/pages/user_orders/product_info/controller/product_info_controller.dart';
import 'package:belcka/pages/user_orders/product_info/view/widgets/product_info_container.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProductInfoScreen extends StatefulWidget {
  const ProductInfoScreen({super.key});
  @override
  State<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  final controller = Get.put(ProductInfoController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Obx(
              () => Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: OrdersBaseAppBar(
              appBar: AppBar(),
              title: 'product_info'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
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
                  ? ProductInfoContainer()
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      Padding(
        padding: EdgeInsets.only(right: 16),
        child: Row(children: [
          Icon(Icons.more_vert_outlined),
        ]),
      )
    ];
  }
}
