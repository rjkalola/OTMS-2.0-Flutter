import 'package:belcka/pages/user_orders/product_details/controller/product_details_controller.dart';
import 'package:belcka/pages/user_orders/product_details/view/widgets/product_details_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/utils/app_utils.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final controller = Get.put(ProductDetailsController());
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(
            () => Container(
          color: backgroundColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'product_details'.tr,
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
                      : Padding(padding: EdgeInsets.zero,
                  child: Visibility(
                    visible: controller.isMainViewVisible.value,
                    child: ProductDetailsContainer(),
                  ),),
            ),
          ),
        ),
      ),
    ));
  }
}
