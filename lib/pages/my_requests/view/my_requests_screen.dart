import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/pages/my_requests/controller/my_requests_controller.dart';
import 'package:belcka/pages/my_requests/view/widgets/request_card.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/text/toolbar_menu_item_text_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../utils/app_constants.dart';

class MyRequestsScreen extends StatelessWidget implements DateFilterListener {
  final controller = Get.put(MyRequestsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();

    return Obx(() => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
            child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: (controller.isFromMyProfile.value &&
                    !controller.isOtherUserProfile.value)
                ? "my_requests".tr
                : "requests".tr,
            isCenterTitle: false,
            bgColor: dashBoardBgColor_(context),
            isBack: true,
            widgets: actionButtons(),
          ),
          backgroundColor: dashBoardBgColor_(context),
          body: ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: controller.isInternetNotAvailable.value
                ? Center(
                    child: Text("no_internet_text".tr),
                  )
                : Visibility(
                    visible: controller.isMainViewVisible.value,
                    child: Column(
                      children: [
                        // Horizontally scrollable filter design
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                        //   child: DateFilterMyRequestOptionsHorizontalList(
                        //     listener: this,
                        //   ),
                        // ),
                        // Requests List
                        DateFilterOptionsHorizontalList(
                          padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
                          startDate: controller.startDate,
                          endDate: controller.endDate,
                          listener: this,
                          selectedPosition: controller.selectedDateFilterIndex,
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(12),
                            itemCount: controller.myRequestList.length,
                            itemBuilder: (context, index) {
                              final request = controller.myRequestList[index];
                              return RequestCard(request: request);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ))));
  }

  void setState(Null Function() param0) {}

  @override
  void onSelectDateFilter(int filterIndex, String filter, String startDate,
      String endDate, String dialogIdentifier) {
    controller.isResetEnable.value = true;
    controller.startDate = startDate;
    controller.endDate = endDate;
    controller.getMyRequestsList(controller.appliedFilters);
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }

  List<Widget>? actionButtons() {
    return [
      Visibility(
        visible: false,
        child: ToolbarMenuItemTextView(
          text: 'reset'.tr,
          padding: EdgeInsets.only(left: 6, right: 14),
          onTap: () {
            controller.clearFilter();
          },
        ),
      ),
      InkWell(
        borderRadius: BorderRadius.circular(45),
        onTap: () async {
          var arguments = {
            AppConstants.intentKey.filterType:
                AppConstants.filterType.myRequestFilter,
            AppConstants.intentKey.filterData: controller.appliedFilters,
          };
          var result =
              await Get.toNamed(AppRoutes.filterScreen, arguments: arguments);
          if (result != null) {
            controller.isResetEnable.value = true;
            controller.appliedFilters = result;
            controller.getMyRequestsList(result);
          }
        },
        child: Visibility(
          visible: !controller.isFromMyProfile.value,
          child: Padding(
            padding: const EdgeInsets.only(right: 9),
            child: ImageUtils.setSvgAssetsImage(
                path: Drawable.filterIcon,
                width: 26,
                height: 26,
                color: primaryTextColor_(Get.context!)),
          ),
        ),
      )
    ];
  }
}

Color getStatusColor(String status) {
  Color color = pendingTextColor_(Get.context!);
  if (status == 'approved') {
    color = approvedTextColor_(Get.context!);
  } else if (status == 'rejected') {
    color = rejectTextColor_(Get.context!);
  }
  return color;
}

Color getRequestTypeColor(int requestType) {
  var requestTypeColors = {
    101: Color(0xFFFF7F00), // Timesheet
    102: Color(0xFFFF7F00), // Work log
    103: Color(0xFF4CBC6D), // Billing Info
    104: Color(0xFF3F51B5), // User Account
    105: Color(0xFFFFC107), // Company
    AppConstants.requestType.penalty: Colors.red, // Company
  };
  return requestTypeColors[requestType] ?? Colors.grey; // Default color
}

String capitalizeFirst(String text) {
  if (text.isEmpty) return '';
  return text[0].toUpperCase() + text.substring(1);
}
