import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/storeman_order_details/controller/storeman_order_details_controller.dart';
import 'package:belcka/storeman_app/storeman_order_details/view/widgets/storeman_order_details_header.dart';
import 'package:belcka/storeman_app/storeman_order_details/view/widgets/storeman_order_products_list.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/textfield/reusable/add_note_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/string_helper.dart';
import '../../../widgets/textfield/reusable/drop_down_text_field.dart';

class StoremanOrderDetailsScreen extends StatefulWidget {
  const StoremanOrderDetailsScreen({super.key});

  @override
  State<StoremanOrderDetailsScreen> createState() =>
      _StoremanOrderDetailsScreenState();
}

class _StoremanOrderDetailsScreenState
    extends State<StoremanOrderDetailsScreen> {
  late final StoremanOrderDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StoremanOrderDetailsController());
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();

    return Obx(
      () => Container(
        color: backgroundColor_(context),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: !StringHelper.isEmptyString(
                      controller.orderInfo.value.orderId)
                  ? "${'order'.tr} ${controller.orderInfo.value.orderId ?? ""}"
                  : "Order Details",
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
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
                          controller.orderDetailsApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => FocusScope.of(context).unfocus(),
                              onPanDown: (_) =>
                                  FocusScope.of(context).unfocus(),
                              child: StoremanOrderDetailsHeader(
                                  item: controller.orderInfo.value,
                                  onListItem: () {}),
                            ),
                            const SizedBox(height: 15),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    StoremanOrderProductsList(),
                                    /*Visibility(
                                      visible: controller.status.value ==
                                              AppConstants.orderStatus.issued ||
                                          controller.status.value ==
                                              AppConstants
                                                  .orderStatus.partialReceived,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20, top: 20),
                                            child: DropDownTextField(
                                              title: 'receive_date'.tr,
                                              controller: controller
                                                  .receiveDateController,
                                              borderRadius: 16,
                                              validators: const [],
                                              onPressed: () {
                                                controller.showDatePickerDialog(
                                                    AppConstants
                                                        .dialogIdentifier
                                                        .selectDate,
                                                    controller.receiveDate,
                                                    DateTime.now(),
                                                    DateTime(2060));
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          AddNoteWidget(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 10, 16, 10),
                                            controller:
                                                controller.noteController,
                                            borderRadius: 16,
                                          )
                                        ],
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                            if (controller.status.value ==
                                AppConstants.orderStatus.received)
                              PrimaryButton(
                                margin: const EdgeInsets.all(14),
                                buttonText: 'proceed'.tr,
                                onPressed: () {
                                  controller.showOrderProceedDialog();
                                },
                                color: Colors.orange,
                              ),
                            if (controller.status.value ==
                                    AppConstants.orderStatus.processing ||
                                controller.status ==
                                    AppConstants.orderStatus.partialReceived)
                              PrimaryButton(
                                margin: const EdgeInsets.all(14),
                                buttonText: 'delivered'.tr,
                                onPressed: () {
                                  if (controller.isProductQuantityValid()) {
                                    if (controller.isValidOrder()) {
                                      controller.showOrderDeliveredDialog();
                                    } else {
                                      AppUtils.showToastMessage(
                                          'msg_storeman_order_note_and_photo'
                                              .tr);
                                    }
                                  } else {
                                    AppUtils.showToastMessage(
                                        'msg_select_at_least_one_qty'.tr);
                                  }
                                },
                                color: Colors.green,
                              ),
                          ],
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}
