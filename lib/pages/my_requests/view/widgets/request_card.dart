import 'package:belcka/pages/my_requests/model/my_request_info.dart';
import 'package:belcka/pages/my_requests/controller/my_requests_controller.dart'
    show MyRequestsController;
import 'package:belcka/pages/my_requests/view/my_requests_screen.dart';
import 'package:belcka/pages/my_requests/view/widgets/request_type_label_widget.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
            margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  String status = request.statusText ?? "";
                  int requestType = request.requestType ?? 0;
                  if (requestType == AppConstants.requestType.billingInfo) {
                    if (status == "pending") {
                      var arguments = {
                        "request_log_id": request.id ?? 0,
                      };
                      controller.moveToScreen(
                          AppRoutes.billingRequestScreen, arguments);
                    } else {
                      if (request.userId == UserUtils.getLoginUserId()) {
                        var arguments = {
                          "user_id": request.userId ?? 0,
                        };
                        controller.moveToScreen(
                            AppRoutes.billingDetailsNewScreen, arguments);
                      } else {
                        var arguments = {
                          "user_id": request.userId ?? 0,
                        };
                        controller.moveToScreen(
                            AppRoutes.otherUserBillingDetailsScreen, arguments);
                      }
                    }
                  } else if (requestType == AppConstants.requestType.shift) {
                    var arguments = {
                      AppConstants.intentKey.ID: request.id ?? 0,
                    };
                    controller.moveToScreen(
                        AppRoutes.workLogRequestScreen, arguments);
                  } else if (requestType == AppConstants.requestType.company) {
                    //Show buttons only if status is pending and both approver/rejecter are null
                    bool showButtons = request.statusText == 'pending' &&
                        request.approvedBy == null &&
                        request.rejectedBy == null;

                    var arguments = {
                      "request_log_id": request.id ?? 0,
                      "showButtons": showButtons,
                    };
                    controller.moveToScreen(
                        AppRoutes.ratesRequestScreen, arguments);
                  } else if (requestType == AppConstants.requestType.leave) {
                    if ((request.status ?? 0) == AppConstants.status.pending ||
                        (request.status ?? 0) == AppConstants.status.approved||
                        (request.status ?? 0) == AppConstants.status.rejected) {
                      var arguments = {
                        AppConstants.intentKey.leaveId: request.leaveId ?? 0,
                        AppConstants.intentKey.fromRequest: true,
                      };
                      controller.moveToScreen(
                          AppRoutes.leaveDetailsScreen, arguments);
                    } else {
                      var arguments = {
                        AppConstants.intentKey.userId: request.userId ?? 0,
                      };
                      controller.moveToScreen(
                          AppRoutes.leaveListScreen, arguments);
                    }
                  } else if (requestType == AppConstants.requestType.penalty) {
                    var arguments = {
                      AppConstants.intentKey.penaltyId: request.penaltyId ?? 0,
                    };
                    controller.moveToScreen(
                        AppRoutes.penaltyDetailsScreen, arguments);
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
                          child: GestureDetector(
                            onTap: () {
                              AppUtils.onClickUserAvatar(request.userId ?? 0);
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                request.userImage ?? "",
                              ),
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
                        "${'note'.tr}: ${(request.note)!.trim()}",
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
