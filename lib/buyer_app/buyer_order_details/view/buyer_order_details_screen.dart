import 'package:belcka/buyer_app/buyer_order_details/controller/buyer_order_details_controller.dart';
import 'package:belcka/buyer_app/buyer_order_details/view/widgets/buyer_order_details_header.dart';
import 'package:belcka/buyer_app/buyer_order_details/view/widgets/buyer_order_products_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
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
        color: backgroundColor_(context),
        child: SafeArea(
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
              // widgets: actionButtons(),
              isSearching: controller.isSearchEnable.value,
              searchController: controller.searchController,
              onValueChange: (value) {
                controller.searchItem(value);
              },
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
                                  Visibility(
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
                                  ),
                                ],
                              )),
                            ),
                            controller.status.value ==
                                        AppConstants.orderStatus.issued ||
                                    controller.status.value ==
                                        AppConstants.orderStatus.partialReceived
                                ? PrimaryButton(
                                    padding: EdgeInsets.all(14),
                                    buttonText: 'receive'.tr,
                                    onPressed: () {
                                      controller.onClickReceiveOrder();
                                    },
                                    color: defaultAccentColor_(context),
                                  )
                                : Container()
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
      const SizedBox(width: 6),
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
                  color: primaryTextColor_(context),
                )
              : ImageUtils.setSvgAssetsImage(
                  path: Drawable.searchIcon,
                  width: 24,
                  height: 24,
                  color: primaryTextColor_(context),
                )),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      // if (UserUtils.isAdmin())
      //   IconButton(
      //     icon: const Icon(Icons.more_vert_outlined),
      //     onPressed: () {},
      //   ),
    ];
  }
}
