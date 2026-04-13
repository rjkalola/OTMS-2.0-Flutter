import 'package:belcka/pages/profile/health_and_safety/report_incidents_list/controller/report_incident_list_controller.dart';
import 'package:belcka/pages/profile/health_and_safety/report_incidents_list/view/report_incident_list_widget.dart';
import 'package:belcka/pages/user_orders/widgets/empty_state_view.dart';
import 'package:belcka/pages/user_orders/widgets/orders_base_app_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ReportIncidentsListScreen extends StatefulWidget {
  const ReportIncidentsListScreen({super.key});

  @override
  State<ReportIncidentsListScreen> createState() => _ReportIncidentsListScreenState();
}

class _ReportIncidentsListScreenState extends State<ReportIncidentsListScreen> {
  final controller = Get.put(ReportIncidentListController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
          () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              appBar: OrdersBaseAppBar(
                appBar: AppBar(),
                title: 'report_incident'.tr,
                isCenterTitle: false,
                isBack: true,
                widgets: actionButtons(),
                bgColor: backgroundColor_(context),
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
                    ? NoInternetWidget(
                  onPressed: () {
                    controller.isInternetNotAvailable.value = false;
                  },
                )
                    : controller.isMainViewVisible.value
                    ? (controller.incidentsReportsList.isNotEmpty) ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: ReportIncidentListWidget(),
                ) : EmptyStateView(
                  title: 'no_data_found'.tr,
                  message:"",
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      InkWell(
        onTap: (){
          controller.moveToScreen(AppRoutes.reportIncidentScreen, null);
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(Icons.add,
            color: primaryTextColor_(context) ,
            size: 25,
          ),
        ),
      ),
      SizedBox(width: 8,),
    ];
  }
}