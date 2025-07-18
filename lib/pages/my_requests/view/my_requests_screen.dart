import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/listener/date_filter_listener.dart';
import 'package:otm_inventory/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:otm_inventory/pages/filter/view/filter_screen.dart';
import 'package:otm_inventory/pages/my_requests/controller/my_requests_controller.dart';
import 'package:otm_inventory/pages/my_requests/model/my_request_info.dart';
import 'package:otm_inventory/pages/my_requests/model/my_requests_list_response.dart';
import 'package:otm_inventory/pages/my_requests/view/widgets/date_filter_my_requests_horizontal_list.dart';
import 'package:otm_inventory/pages/my_requests/view/widgets/request_type_label_widget.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/text/toolbar_menu_item_text_view.dart';
import 'package:path/path.dart';

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
            title: "My Requests",
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
                ? const Center(
                    child: Text("No Internet"),
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
  void onSelectDateFilter(
      String startDate, String endDate, String dialogIdentifier) {
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
        visible: controller.isResetEnable.value,
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
          var result = await Get.toNamed(AppRoutes.filterScreen,
              arguments: controller.appliedFilters);
          if (result != null) {
            controller.isResetEnable.value = true;
            controller.appliedFilters = result;
            controller.getMyRequestsList(result);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: ImageUtils.setSvgAssetsImage(
              path: Drawable.filterIcon,
              width: 26,
              height: 26,
              color: primaryTextColor_(Get.context!)),
        ),
      )
    ];
  }
}

class RequestCard extends StatelessWidget {
  final MyRequestInfo request;

  RequestCard({required this.request});

  final controller = Get.put(MyRequestsController());
  String noteText = "";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // your main card container
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(0),
          child: CardViewDashboardItem(
            margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  String status = request.statusText ?? "";
                  int requestType = request.requestType ?? 0;
                  if (requestType == 103) {
                    if (status == "pending") {
                      var arguments = {
                        "request_log_id": request.id ?? 0,
                      };
                      controller.moveToScreen(
                          AppRoutes.billingRequestScreen, arguments);
                    }
                  } else if (requestType == 102) {
                    var arguments = {
                      AppConstants.intentKey.ID: request.id ?? 0,
                    };
                    controller.moveToScreen(
                        AppRoutes.workLogRequestScreen, arguments);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryTextColor_(context), // Border color
                              width: 1.5, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              request.userImage ?? "",
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${request.userName ?? ""}:\n",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                TextSpan(
                                  text: request.message ?? "",
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Chip(
                          label: Text(
                            capitalizeFirst(request.statusText ?? ""),
                            style: TextStyle(
                              color: getStatusColor(request.statusText ?? ""),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: backgroundColor_(context),
                          shape: StadiumBorder(
                            side: BorderSide(
                                color: getStatusColor(request.statusText ?? ""),
                                width: 2),
                          ),
                        )
                      ],
                    ),
                    if ((request.note?.trim().isNotEmpty) ?? false) ...[
                      SizedBox(height: 8),
                      Text(
                        "Note: ${(request.note)!.trim()}",
                      ),
                    ],
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        request.date ?? "",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ), //... other card content
        ),
        Positioned(
          top: 0,
          left: 16,
          child: RequestTypeLabelWidget(
              label: request.typeName ?? "",
              backgroundColor: getRequestTypeColor(request.requestType ?? 0)),
        ),
      ],
    );
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
  const requestTypeColors = {
    101: Color(0xFFFF7F00), // Timesheet
    102: Color(0xFFFF7F00), // Work log
    103: Color(0xFF4CBC6D), // Billing Info
    104: Color(0xFF3F51B5), // User Account
    105: Color(0xFFFFC107), // Company
  };
  return requestTypeColors[requestType] ?? Colors.grey; // Default color
}

String capitalizeFirst(String text) {
  if (text.isEmpty) return '';
  return text[0].toUpperCase() + text.substring(1);
}
