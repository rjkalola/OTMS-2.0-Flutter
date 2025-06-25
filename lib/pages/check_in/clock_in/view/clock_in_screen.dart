import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/clock_in/controller/clock_in_controller.dart';
import 'package:otm_inventory/pages/check_in/clock_in/view/widgets/my_day_log_list_view.dart';
import 'package:otm_inventory/pages/check_in/clock_in/view/widgets/my_day_logs_title.dart';
import 'package:otm_inventory/pages/check_in/clock_in/view/widgets/start_shift_button.dart';
import 'package:otm_inventory/pages/check_in/clock_in/view/widgets/stop_shift_button.dart';
import 'package:otm_inventory/pages/check_in/clock_in/view/widgets/work_time_details_view.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class ClockInScreen extends StatefulWidget {
  const ClockInScreen({super.key});

  @override
  State<ClockInScreen> createState() => _ClockInScreenState();
}

class _ClockInScreenState extends State<ClockInScreen> {
  final controller = Get.put(ClockInController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: dashBoardBgColor,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: dashBoardBgColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor,
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "",
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor,
            // widgets: actionButtons()
          ),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? const NoInternetWidget()
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  WorkTimeDetailsView(),
                                  (controller.workLogData.value.userIsWorking ??
                                          false)
                                      ? StopShiftButton()
                                      : StartShiftButton(),
                                  MyDayLogsTitle(),
                                  MyDayLogListView(),
                                  // CheckInAddressesListView()
                                ],
                              ),
                            ),
                            // FooterButtonCheckInSwitchProject()
                          ],
                        )));
          }),
        ),
      ),
    );
  }

  List<Widget>? actionButtons() {
    return [
      IconButton(
        icon: SvgPicture.asset(Drawable.timesheetClockInScreenIcon, width: 28),
        onPressed: () {},
      ),
      SizedBox(
        width: 2,
      ),
      SizedBox(
        width: 24,
        height: 24,
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon:
              SvgPicture.asset(Drawable.myRequestClockInScreenIcon, width: 21),
          onPressed: () {},
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8),
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: SvgPicture.asset(Drawable.teamClockInScreenIcon, width: 22),
          onPressed: () {},
        ),
      ),
    ];
  }
}
