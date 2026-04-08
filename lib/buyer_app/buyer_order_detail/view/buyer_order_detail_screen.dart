import 'package:belcka/buyer_app/buyer_order_detail/controller/buyer_order_detail_controller.dart';
import 'package:belcka/buyer_app/buyer_order_detail/view/widgets/buyer_order_detail_header.dart';
import 'package:belcka/buyer_app/buyer_order_detail/view/widgets/buyer_order_detail_products_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/string_helper.dart';

class BuyerOrderDetailScreen extends StatefulWidget {
  const BuyerOrderDetailScreen({super.key});

  @override
  State<BuyerOrderDetailScreen> createState() => _BuyerOrderDetailScreenState();
}

class _BuyerOrderDetailScreenState extends State<BuyerOrderDetailScreen> {
  late final BuyerOrderDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(BuyerOrderDetailController());
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();

    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          top: false,
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
              widgets: actionButtons(),
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
                              child: BuyerOrderDetailHeader(
                                  item: controller.orderInfo.value,
                                  onListItem: () {}),
                            ),
                            const SizedBox(height: 15),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    BuyerOrderDetailProductsList(),
                                  ],
                                ),
                              ),
                            ),
                            if (controller.isCancelCheck.value)
                              PrimaryButton(
                                margin: const EdgeInsets.all(14),
                                buttonText: 'cancel'.tr,
                                onPressed: () {
                                  if (!controller.hasSelectedCancelItem()) {
                                    AppUtils.showToastMessage(
                                        'msg_select_at_least_one_qty'.tr);
                                    return;
                                  }
                                  if (controller.isProductQuantityValid()) {
                                    if (controller.isValidOrder()) {
                                      controller.showOrderCancelDialog();
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
                                color: controller.hasSelectedCancelItem()
                                    ? Colors.redAccent
                                    : Colors.grey,
                              ),
                          ],
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: controller.isCancelQtyAvailable.value ||
            controller.status.value != AppConstants.orderStatus.inStock,
        child: IconButton(
          icon: const Icon(Icons.more_vert_outlined),
          onPressed: () {
            controller.showMenuItemsDialog(Get.context!);
          },
        ),
      ),
    ];
  }
}
