import 'package:belcka/pages/user_orders/order_details/view/widgets/order_status_alert_dialog.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/controller/storeman_internal_order_details_controller.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/view/widgets/internal_order_details_list_with_quantity.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/view/widgets/order_details_header_view.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/view/widgets/order_details_orders_list.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class StoremanInternalOrderDetailsScreen extends StatefulWidget {
  const StoremanInternalOrderDetailsScreen({super.key});

  @override
  State<StoremanInternalOrderDetailsScreen> createState() =>
      _StoremanInternalOrderDetailsScreenState();
}

class _StoremanInternalOrderDetailsScreenState
    extends State<StoremanInternalOrderDetailsScreen> {
  final controller = Get.put(StoremanInternalOrderDetailsController());
  late TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Obx(
          () => GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: !StringHelper.isEmptyString(
                    controller.orderInfo.value.orderId)
                    ? "${'order'.tr} ${controller.orderInfo.value.orderId ?? ""}"
                    : "",
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
                        ? Column(
                            children: [
                              OrderDetailsHeaderView(),
                              SizedBox(height: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Row(
                                  children: [
                                    // Return Button
                                    if (controller.status.value ==
                                        AppConstants
                                            .internalOrderStatus.delivered)
                                      OutlinedButton(
                                        onPressed: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                OrderStatusAlertDialog(
                                              title:
                                                  'Return Order ${controller.orderDetails[0].orderId ?? ""}',
                                              description:
                                                  'Please provide a reason for returning this order.'
                                                  'This information is required for project tracking and order history',
                                              showTextField: false,
                                              confirmText: "return_order".tr,
                                              onConfirm: () {
                                                controller.updateOrderStatus(
                                                    8, "");
                                                Navigator.pop(context);
                                              },
                                              onCancel: () =>
                                                  Navigator.pop(context),
                                            ),
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.red,
                                          side: const BorderSide(
                                              color: Colors.red),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                        ),
                                        child: TitleTextView(
                                          text: "return".tr,
                                          fontSize: 15,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),

                                    Spacer(),
                                    //Cancel button
                                    if (controller.status.value == AppConstants.internalOrderStatus.newOrder ||
                                        controller.status.value ==
                                            AppConstants.internalOrderStatus
                                                .collected ||
                                        controller.status.value ==
                                            AppConstants
                                                .internalOrderStatus.ready ||
                                        controller.status.value ==
                                            AppConstants.internalOrderStatus
                                                .preparing ||
                                        controller.status.value ==
                                            AppConstants
                                                .internalOrderStatus.ready)
                                      OutlinedButton(
                                        onPressed: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                OrderStatusAlertDialog(
                                              title:
                                                  'Cancel Order ${controller.orderDetails[0].orderId ?? ""}',
                                              description:
                                                  'Please provide a reason for cancelling this order.'
                                                  'This information is required for project tracking and order history',
                                              showTextField: true,
                                              controller: _reasonController,
                                              onConfirm: () {
                                                controller.updateOrderStatus(
                                                    7,
                                                    _reasonController.text
                                                        .trim());
                                                _reasonController.text = "";
                                              },
                                              onCancel: () =>
                                                  Navigator.pop(context),
                                            ),
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.green,
                                          side: const BorderSide(
                                              color: Colors.green),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                        ),
                                        child: TitleTextView(
                                          text: "cancel_order".tr,
                                          fontSize: 15,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    if (controller.status.value !=
                                        AppConstants.internalOrderStatus.ready)
                                    OrderDetailsOrdersList(),
                                    if (controller.status.value ==
                                        AppConstants.internalOrderStatus.ready)
                                    InternalOrderDetailsListWithQuantity()
                                  ],
                                ),
                              )),
                              //ready to collect
                              if (controller.status.value == AppConstants.internalOrderStatus.newOrder ||
                                  controller.status.value == AppConstants.internalOrderStatus.confirmed )
                                PrimaryButton(
                                  margin: const EdgeInsets.all(14),
                                  buttonText: 'ready_to_collect'.tr,
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          OrderStatusAlertDialog(
                                        title:
                                            'Confirm Order ${controller.orderDetails[0].orderId ?? ""}',
                                        description:
                                            "Are you sure you want to mark this order as ready for Collect?",
                                        showTextField: false,
                                        confirmText: "confirm".tr,
                                        confirmColor: Colors.green,
                                        onConfirm: () {
                                          controller.updateOrderStatus(4, "");
                                          Navigator.pop(context);
                                        },
                                        onCancel: () => Navigator.pop(context),
                                      ),
                                    );
                                  },
                                  color: Colors.green,
                                ),
                              //ready to deliver
                              if (controller.status.value ==
                                  AppConstants.internalOrderStatus.preparing)
                                PrimaryButton(
                                  margin: const EdgeInsets.all(14),
                                  buttonText: 'ready_to_deliver'.tr,
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          OrderStatusAlertDialog(
                                        title:
                                            'Confirm Order ${controller.orderDetails[0].orderId ?? ""}',
                                        description:
                                            "Are you sure you want to mark this order as out for delivery?",
                                        showTextField: false,
                                        confirmText: "confirm".tr,
                                        confirmColor: Colors.green,
                                        onConfirm: () {
                                          controller.updateOrderStatus(5, "");
                                          Navigator.pop(context);
                                        },
                                        onCancel: () => Navigator.pop(context),
                                      ),
                                    );
                                  },
                                  color: Colors.green,
                                ),
                              //delivered
                              if (controller.status.value ==
                                  AppConstants.internalOrderStatus.ready && controller.getSelectedItemsCount() > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Cancel Button
                                    Expanded(
                                      child: SizedBox(
                                        height: 45,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              for (var order in controller.orderDetails[0].orders!) {
                                                order.isSelected = false;
                                              }
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            elevation: 4,
                                            shape: const StadiumBorder(),
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16,),
                                    // Confirm Button
                                    Expanded(
                                      child: SizedBox(
                                        height: 45,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  OrderStatusAlertDialog(
                                                    title:
                                                    'Confirm Order ${controller.orderDetails[0].orderId ?? ""}',
                                                    description:
                                                    "Are you sure you want to mark this order as delivered?",
                                                    showTextField: false,
                                                    confirmText: "confirm".tr,
                                                    confirmColor: Colors.green,
                                                    onConfirm: () {
                                                      controller.updateOrderStatus(6, "");
                                                      Navigator.pop(context);
                                                    },
                                                    onCancel: () => Navigator.pop(context),
                                                  ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            elevation: 4,
                                            shape: const StadiumBorder(),
                                          ),
                                          child: const Text(
                                            'Confirm',
                                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
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
