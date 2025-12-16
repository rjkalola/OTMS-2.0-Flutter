import 'package:belcka/pages/common/common_bottom_navigation_bar_widget.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/project/address_details/controller/address_details_controller.dart';
import 'package:belcka/pages/project/address_details/view/widgets/address_details_card.dart';
import 'package:belcka/pages/project/address_details/view/widgets/address_details_grid_items.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({super.key});

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen>
    implements DateFilterListener {
  final controller = Get.put(AddressDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          child: Scaffold(
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.addressDetailsInfo?.name ?? "",
              isCenterTitle: false,
              bgColor: dashBoardBgColor_(context),
              isBack: true,
              widgets: actionButtons(),
              onBackPressed: () {
                controller.onBackPress();
              },
            ),
            backgroundColor: dashBoardBgColor_(context),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? Center(
                child: Text('no_internet_text'.tr),
              )
                  : Visibility(
                visible: controller.isMainViewVisible.value,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AddressDetailsCard(),
                      const SizedBox(height: 16),
                      DateFilterOptionsHorizontalList(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        startDate: controller.startDate,
                        endDate: controller.endDate,
                        listener: this,
                        selectedPosition:
                        controller.selectedDateFilterIndex,
                      ),
                      SizedBox(height: 16),
                      AddressDetailsGridItems()
                    ],
                  ),
                )
              ),
            ),
            bottomNavigationBar: CommonBottomNavigationBarWidget(),
          ),
        )));
  }
  List<Widget>? actionButtons() {
    return [
      // Visibility(
      //   visible: controller.isResetEnable.value,
      //   child: ToolbarMenuItemTextView(
      //     text: 'reset'.tr,
      //     padding: EdgeInsets.only(left: 0, right: 0),
      //     onTap: () {
      //       controller.clearFilter();
      //     },
      //   ),
      // ),
      const SizedBox(width: 10),
      Visibility(
        visible: true,
        child: IconButton(
          icon: Icon(Icons.more_vert_outlined),
          onPressed: () {
            controller.showMenuItemsDialog(Get.context!);
          },
        ),
      ),
    ];
  }

  @override
  void onSelectDateFilter(int filterIndex, String filter,String startDate, String endDate, String dialogIdentifier) {
    // TODO: implement onSelectDateFilter
    controller.isResetEnable.value = true;
    controller.startDate = startDate;
    controller.endDate = endDate;
    if (StringHelper.isEmptyString(startDate) &&
        StringHelper.isEmptyString(endDate)) {
      controller.clearFilter();
    }
    controller.loadAddressDetailsData(true);
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}
