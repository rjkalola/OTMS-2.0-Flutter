import 'package:belcka/pages/user_orders/hire_module/create_hire_order/controller/create_hire_order_controller.dart';
import 'package:belcka/pages/user_orders/hire_module/create_hire_order/view/widgets/create_hire_order_header_view.dart';
import 'package:belcka/pages/user_orders/hire_module/create_hire_order/view/widgets/create_hire_order_product_list.dart';
import 'package:belcka/pages/user_orders/widgets/empty_cart_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CreateHireOrderScreen extends StatefulWidget {
  const CreateHireOrderScreen({super.key});

  @override
  State<CreateHireOrderScreen> createState() => _CreateHireOrderScreenState();
}

class _CreateHireOrderScreenState extends State<CreateHireOrderScreen> {
  final controller = Get.put(CreateHireOrderController());
 
  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          top: false,
          child: Obx(
            () => GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                backgroundColor: dashBoardBgColor_(context),
                appBar: BaseAppBar(
                  appBar: AppBar(),
                  title: 'create_order'.tr,
                  isCenterTitle: false,
                  isBack: true,
                  bgColor: backgroundColor_(context),
                  autoFocus: true,
                  isClearVisible: false.obs,
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
                          },
                        )
                      : controller.isMainViewVisible.value
                          ? (controller.cartList.isNotEmpty)
                              ? Column(
                                  children: [
                                    CreateHireOrderHeaderView(),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Expanded(
                                      child: CreateHireOrderProductList(
                                        products: controller.cartList,
                                      ),
                                    ),
                                  ],
                                )
                              : EmptyCartView()
                          : const SizedBox.shrink(),
                ),
                bottomNavigationBar: SafeArea(
                  child: Visibility(
                    visible: controller.isMainViewVisible.value &&
                        controller.cartList.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Opacity(
                        opacity: 1.0,
                        child: PrimaryButton(
                          buttonText: "order_now".tr,
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            controller.toggleCreateOrder();
                          },
                        ),
                      ),
                    ),
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
