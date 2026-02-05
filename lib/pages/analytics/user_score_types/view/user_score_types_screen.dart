import 'package:belcka/pages/analytics/user_score_types/controller/user_score_types_controller.dart';
import 'package:belcka/pages/analytics/user_score_types/view/widgets/user_score_types_header_view.dart';
import 'package:belcka/pages/analytics/user_score_types/view/widgets/user_score_types_section_container_view.dart';
import 'package:belcka/pages/common/listener/date_filter_listener.dart';
import 'package:belcka/pages/common/widgets/date_filter_options_horizontal_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserScoreTypesScreen extends StatefulWidget {
  const UserScoreTypesScreen({super.key});

  @override
  State<UserScoreTypesScreen> createState() => _UserScoreTypesScreenState();
}

class _UserScoreTypesScreenState extends State<UserScoreTypesScreen> with SingleTickerProviderStateMixin
    implements DateFilterListener {
  final controller = Get.put(UserScoreTypesController());
  late AnimationController animatedController;
  int selectedTab = 0;
  String title = "warnings";

  @override
  void initState() {
    super.initState();
    animatedController =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
  }

  @override
  void dispose() {
    animatedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Obx(
              () => Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: '${title}'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
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
                },
              )
                  : controller.isMainViewVisible.value
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserScoreTypesHeaderView(),
                  const SizedBox(height: 16),
                  DateFilterOptionsHorizontalList(
                    padding: EdgeInsets.fromLTRB(14, 0, 14, 6),
                    startDate: controller.startDate,
                    endDate: controller.endDate,
                    listener: this,
                    selectedPosition:
                    controller.selectedDateFilterIndex,
                  ),
                  Expanded(child: UserScoreTypesSectionContainerView()),
                ],
              )
                  : SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onSelectDateFilter(int filterIndex, String filter, String startDate,
      String endDate, String dialogIdentifier) {
    int index = 1;
    if (filter != "Custom" && filter != "Reset") {
      index = filterIndex;
    }
    Get.find<AppStorage>().setTimesheetDateFilterIndex(index);

    controller.startDate = startDate;
    controller.endDate = endDate;

    if (StringHelper.isEmptyString(startDate) &&
        StringHelper.isEmptyString(endDate)) {
      //controller.appliedFilters = {};
    }
    controller.getUserAnalyticsAPI();
    print("startDate:" + startDate);
    print("endDate:" + endDate);
  }

  List<Widget>? actionButtons() {
    return [
      IconButton(
        icon: Icon(Icons.more_vert_outlined),
        onPressed: () {

        },
      ),
    ];
  }

  Widget _animatedCard({required int index, required Widget child}) {
    final animation = CurvedAnimation(
      parent: animatedController,
      curve: Interval(0.2 * index, 1, curve: Curves.easeOut),
    );

    return SlideTransition(
      position:
      Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
          .animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: child,
        ),
      ),
    );
  }
}

