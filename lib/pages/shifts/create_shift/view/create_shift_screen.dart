import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/shifts/create_shift/controller/create_shift_controller.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/add_another_break_button.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/break_title_text.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/breaks_list_view.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/manage_week_days_view.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/select_shift_time_row.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/shift_name_textfield.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/manage_shift_time.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/manage_shift_title.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/shift_type.dart';
import 'package:otm_inventory/pages/teams/create_team/controller/create_team_controller.dart';
import 'package:otm_inventory/pages/teams/create_team/view/widgets/add_team_member.dart';
import 'package:otm_inventory/pages/teams/create_team/view/widgets/supervisor_textfield.dart';
import 'package:otm_inventory/pages/teams/create_team/view/widgets/team_members_list.dart';
import 'package:otm_inventory/pages/teams/create_team/view/widgets/team_name_textfield.dart';
import 'package:otm_inventory/pages/teams/team_list/controller/team_list_controller.dart';
import 'package:otm_inventory/pages/teams/team_list/view/widgets/search_team.dart';
import 'package:otm_inventory/pages/teams/team_list/view/widgets/teams_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/buttons/ContinueButton.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';
import 'package:otm_inventory/widgets/text/TitleTextView.dart';
import 'package:otm_inventory/widgets/textfield/text_field_underline.dart';

class CreateShiftScreen extends StatefulWidget {
  const CreateShiftScreen({super.key});

  @override
  State<CreateShiftScreen> createState() => _CreateShiftScreenState();
}

class _CreateShiftScreenState extends State<CreateShiftScreen> {
  final controller = Get.put(CreateShiftController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: dashBoardBgColor,
        statusBarIconBrightness: Brightness.dark));
    return Obx(
      () => Container(
        color: dashBoardBgColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: dashBoardBgColor,
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.title.value,
              isCenterTitle: false,
              isBack: true,
              bgColor: dashBoardBgColor,
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
                          // controller.getTeamListApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            Expanded(
                                child: SingleChildScrollView(
                              child: Form(
                                key: controller.formKey,
                                child: Column(
                                  children: [
                                    ManageShiftTitle(),
                                    ManageShiftTime(),
                                    ManageWeekDaysView()
                                  ],
                                ),
                              ),
                            )),
                            PrimaryButton(
                                padding: EdgeInsets.fromLTRB(14, 18, 14, 16),
                                buttonText: 'save'.tr,
                                color: controller.isSaveEnable.value
                                    ? defaultAccentColor
                                    : defaultAccentLightColor,
                                onPressed: () {
                                  controller.onSubmit();
                                })
                          ],
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  Widget divider_() => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Divider(
          height: 0,
        ),
      );

  List<Widget>? actionButtons() {
    return [
     /* TextButton(
        onPressed: () {
          controller.onSubmit();
        },
        child: PrimaryTextView(
          text: 'save'.tr,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: controller.isSaveEnable.value
              ? defaultAccentColor
              : defaultAccentLightColor,
        ),
      ),
      SizedBox(
        width: 3,
      ),*/
      Visibility(
        visible: (controller.shiftInfo.value.id ?? 0) > 0,
        child: GestureDetector(
          onTap: () {
            controller.showMenuItemsDialog(context);
          },
          child: Icon(Icons.more_vert_outlined),
        ),
      ),
      Visibility(
        visible: (controller.shiftInfo.value.id ?? 0) > 0,
        child: SizedBox(
          width: 12,
        ),
      ),
    ];
  }
}
