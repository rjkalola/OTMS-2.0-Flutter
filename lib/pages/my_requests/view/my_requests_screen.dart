import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/listener/date_filter_listener.dart';
import 'package:otm_inventory/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:otm_inventory/pages/my_requests/controller/my_requests_controller.dart';
import 'package:otm_inventory/pages/my_requests/model/my_request_info.dart';
import 'package:otm_inventory/pages/my_requests/model/my_requests_list_response.dart';
import 'package:otm_inventory/pages/my_requests/view/widgets/date_filter_my_requests_horizontal_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';

import '../../../utils/app_constants.dart';

class MyRequestsScreen extends StatelessWidget implements DateFilterListener {
  final controller = Get.put(MyRequestsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        color: dashBoardBgColor,
        child: SafeArea(
            child: Scaffold(
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "My Requests",
            isCenterTitle: false,
            bgColor: dashBoardBgColor,
            isBack: true,
          ),
          backgroundColor: dashBoardBgColor,
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
                          child: DateFilterMyRequestOptionsHorizontalList(
                            listener: this,
                          ),
                        ),
                        // Requests List
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
    // TODO: implement onSelectDateFilter
    //controller.isResetEnable.value = true;
    controller.startDate = startDate;
    controller.endDate = endDate;
    controller.getMyRequestsList();
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }
}

class RequestCard extends StatelessWidget {
  final MyRequestInfo request;

  RequestCard({required this.request});

  final controller = Get.put(MyRequestsController());

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () {
            String status = request.statusText ?? "";
            int requestType = request.requestType ?? 0;
            if (status == "pending") {
              var arguments = {
                "request_log_id": request.id ?? 0,
              };

              if (requestType == 103) {
                controller.moveToScreen(
                    AppRoutes.billingRequestScreen, arguments);
              }
            }
            /*var arguments = {
              AppConstants.intentKey.ID: request.id ?? 0,
            };

              controller.moveToScreen(
                  AppRoutes.workLogRequestScreen, arguments);*/
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
                        color: Colors.black, // Border color
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
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextSpan(
                            text: request.message ?? "",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      capitalizeFirst(request.statusText ?? ""),
                      style: TextStyle(
                        color: getStatusColor(request.statusText ?? ""),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: getStatusColor(request.statusText ?? "")
                        .withOpacity(0.1),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: getStatusColor(request.statusText ?? ""),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              Text(
                (request.rejectReason?.trim().isEmpty ?? true)
                    ? ""
                    : "Note: ${request.rejectReason!}",
              ),
              SizedBox(height: 8),
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
    );
  }
}

Color getStatusColor(String status) {
  Color color = primaryTextColor;
  if (status == 'approved') {
    color = Colors.green;
  } else if (status == 'rejected') {
    color = Colors.red;
  }
  return color;
}

String capitalizeFirst(String text) {
  if (text.isEmpty) return '';
  return text[0].toUpperCase() + text.substring(1);
}
