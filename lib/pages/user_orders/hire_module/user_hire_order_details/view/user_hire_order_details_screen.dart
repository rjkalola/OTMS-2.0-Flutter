import 'package:belcka/pages/user_orders/hire_module/user_hire_order_details/controller/user_hire_order_details_controller.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_order_details/view/widgets/request_hire_order_details_product_list.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_order_details/view/widgets/user_hire_order_details_header.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_order_details/view/widgets/user_hire_order_details_product_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/checkbox/custom_checkbox.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserHireOrderDetailsScreen extends StatefulWidget {
  const UserHireOrderDetailsScreen({super.key});

  @override
  State<UserHireOrderDetailsScreen> createState() =>
      _UserHireOrderDetailsScreenState();
}

class _UserHireOrderDetailsScreenState
    extends State<UserHireOrderDetailsScreen> {
  late final UserHireOrderDetailsController controller;
  final RxBool isClearVisible = false.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(UserHireOrderDetailsController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<UserHireOrderDetailsController>()) {
      Get.delete<UserHireOrderDetailsController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();

    return Obx(
      () {
        final order = controller.orderInfo.value;
        final products = controller.productsList.toList();
        return Container(
          color: backgroundColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: !StringHelper.isEmptyString(order.orderId)
                    ? "${'order'.tr} ${order.orderId ?? ''}"
                    : "",
                isCenterTitle: false,
                isBack: true,
                bgColor: backgroundColor_(context),
                onValueChange: (value) {},
                autoFocus: true,
                isClearVisible: isClearVisible,
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
                          controller.loadDetail();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            UserHireOrderDetailsHeader(
                              item: order,
                              onListItem: () {},
                            ),
                            const SizedBox(height: 15),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    controller.isRequestFlow.value
                                        ? RequestHireOrderDetailsProductList(
                                            products: products,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            onToggleProduct: controller
                                                .onToggleProductSelection,
                                          )
                                        : UserHireOrderDetailsProductList(
                                            products: products,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            if (controller.isRequestFlow.value)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 8, 14, 14),
                                child: controller.showHireRequestApprove.value
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: PrimaryButton(
                                              buttonText: 'cancel'.tr,
                                              onPressed: controller
                                                  .onRequestCancelSelectedTap,
                                              color: Colors.redAccent,
                                              height: 46,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: PrimaryButton(
                                              buttonText: 'approve'.tr,
                                              color: Colors.green,
                                              onPressed: controller
                                                  .onRequestApproveSelectedTap,
                                              height: 46,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                    : PrimaryButton(
                                        buttonText: 'cancel'.tr,
                                        onPressed: controller
                                            .onRequestCancelSelectedTap,
                                        color: Colors.redAccent,
                                        height: 46,
                                        fontSize: 15,
                                      ),
                              ),
                            if (!controller.isRequestFlow.value &&
                                controller.isHiredStatus)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 14, 2),
                                child: Row(
                                  children: [
                                    CustomCheckbox(
                                      mValue: controller.needService.value,
                                      onValueChange:
                                          controller.onNeedServiceChanged,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Need Service',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: primaryTextColor_(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (!controller.isRequestFlow.value &&
                                controller.isHiredStatus)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 8, 14, 14),
                                child: PrimaryButton(
                                  buttonText: 'return'.tr,
                                  onPressed: controller.onReturnTap,
                                  color: Colors.orange,
                                  height: 46,
                                  fontSize: 16,
                                ),
                              ),
                            if (!controller.isRequestFlow.value &&
                                controller.isInServiceStatus)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(14, 8, 14, 14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: PrimaryButton(
                                        buttonText: 'Available To Hire',
                                        onPressed:
                                            controller.onAvailableToHireTap,
                                        color: Colors.green,
                                        height: 46,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: PrimaryButton(
                                        buttonText: 'damaged'.tr,
                                        onPressed: controller.onDamagedTap,
                                        color: Colors.redAccent,
                                        height: 46,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
