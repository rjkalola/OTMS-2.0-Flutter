import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/controller/home_tab_controller.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/action_buttons_dots_list.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/action_buttons_list.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/analytics_divider.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/analytics_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/earning_summary_divider.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/earning_summery_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/home_tab_header_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/join_company_request_divider.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/join_company_request_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/location_update_divider.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/location_update_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/pending_approval_tasks_divider.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/pending_approval_tasks_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/pending_requests_divider.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/pending_requests_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/pending_tasks_divider.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/pending_tasks_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/schedule_breaks_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/user_score_divider.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/user_score_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/work_log_details_divider.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/work_log_details_view.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/view/widgets/action_buttons_list.dart';
import 'package:otm_inventory/utils/app_utils.dart';

import '../../../../../res/colors.dart';
import '../../../../../utils/app_storage.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // with AutomaticKeepAliveClientMixin {
  final controller = Get.put(HomeTabController());
  late var userInfo = UserInfo();
  int selectedActionButtonPagerPosition = 0;

  @override
  void initState() {
    // showProgress();
    // setHeaderActionButtons();
    // userInfo = Get.find<AppStorage>().getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: dashBoardTabBgColor_(context),
        // backgroundColor: const Color(0xfff4f5f7),
        body: Visibility(
          visible: controller.isMainViewVisible.value,
          child: Column(children: [
            HomeTabHeaderView(),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6))),
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                      height: 26,
                    ),
                    HomeTabActionButtonsList(),
                    HomeTabActionButtonsDotsList(),
                    Divider(
                      thickness: 3,
                      color: dividerColor,
                    ),
                    JoinCompanyRequestView(),
                    JoinCompanyRequestDivider(),
                    UserScoreView(),
                    UserScoreDivider(),
                    PendingRequestsView(),
                    PendingRequestsDivider(),
                    PendingTasksView(),
                    PendingTasksDivider(),
                    PendingApprovalTasksView(),
                    PendingApprovalTasksDivider(),
                    AnalyticsView(),
                    AnalyticsDivider(),
                    Visibility(
                      visible: AppUtils.isUserCheckIn(
                          controller.dashboardResponse.value.checkinId),
                      child: Column(
                        children: [
                          WorkLogDetailsView(),
                          WorkLogDetailsDivider(),
                          EarningSummaryView(),
                          EarningSummaryDivider(),
                          ScheduleBreaksView(),
                          LocationUpdateView(),
                          LocationUpdateDivider()
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

// @override
// bool get wantKeepAlive => true;

// @override
// void dispose() {
//   homeTabController.dispose();
//   super.dispose();
// }
}
