import 'package:belcka/buyer_app/buyer_order_details/controller/buyer_order_details_controller.dart';
import 'package:belcka/buyer_app/buyer_order_details/view/widgets/buyer_order_details_header.dart';
import 'package:belcka/buyer_app/buyer_order_details/view/widgets/buyer_order_products_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../utils/string_helper.dart';

class BuyerOrderDetailsScreen extends StatefulWidget {
  const BuyerOrderDetailsScreen({super.key});

  @override
  State<BuyerOrderDetailsScreen> createState() =>
      _BuyerOrderDetailsScreenState();
}

class _BuyerOrderDetailsScreenState extends State<BuyerOrderDetailsScreen> {
  final controller = Get.put(BuyerOrderDetailsController());

  @override
  void initState() {
    super.initState();
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
                  : "",
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
              onValueChange: (value) {

              },
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
                          // controller.getCompanyDetailsApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            BuyerOrderDetailsHeader(
                                item: controller.orderInfo.value,
                                onListItem: () {}),
                            SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                  child: Column(
                                children: [
                                  BuyerOrderProductsList(),
                                /*  Visibility(
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
                                            validators: [],
                                            onPressed: () {
                                              controller.showDatePickerDialog(
                                                  AppConstants.dialogIdentifier
                                                      .selectDate,
                                                  controller.receiveDate,
                                                  DateTime.now(),
                                                  DateTime(2060));
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        AddNoteWidget(
                                          padding: EdgeInsets.fromLTRB(
                                              16, 10, 16, 10),
                                          controller: controller.noteController,
                                          borderRadius: 16,
                                        )
                                      ],
                                    ),
                                  ),*/
                                ],
                              )),
                            ),
                            // controller.status.value ==
                            //             AppConstants.orderStatus.issued ||
                            //         controller.status.value ==
                            //             AppConstants.orderStatus.partialReceived
                            //     ? PrimaryButton(
                            //         margin: EdgeInsets.all(14),
                            //         buttonText: 'receive'.tr,
                            //         onPressed: () {
                            //           controller.showReceiveOrderDialog();
                            //         },
                            //         color: defaultAccentColor_(context),
                            //       )
                            //     : Container()
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
        visible: controller.isCancelQtyAvailable.value,
        child: IconButton(
          icon: Icon(Icons.more_vert_outlined),
          onPressed: () {
            controller.showMenuItemsDialog(Get.context!);
          },
        ),
      ),
    ];
  }

}
