import 'package:belcka/pages/check_in/user_check_out/controller/user_check_out_controller.dart';
import 'package:belcka/pages/check_in/user_check_out/view/widgets/check_in_out_display_note_widget.dart';
import 'package:belcka/pages/check_in/user_check_out/view/widgets/user_check_out_footer.dart';
import 'package:belcka/pages/check_in/user_check_out/view/widgets/user_check_out_header.dart';
import 'package:belcka/pages/check_in/user_check_out/view/widgets/user_check_out_info_card.dart';
import 'package:belcka/pages/check_in/user_check_out/view/widgets/user_check_out_summary_card.dart';
import 'package:belcka/pages/check_in/user_check_out/view/widgets/user_check_out_task_section.dart';
import 'package:belcka/pages/check_in/user_check_out/view/widgets/user_check_out_times_row.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/textfield/reusable/add_note_widget.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserCheckOutScreen extends StatefulWidget {
  const UserCheckOutScreen({super.key});

  @override
  State<UserCheckOutScreen> createState() => _UserCheckOutScreenState();
}

class _UserCheckOutScreenState extends State<UserCheckOutScreen> {
  final controller = Get.put(UserCheckOutController());

  static const Color _addressIconBg = Color(0xFFE8F3FC);
  static const Color _tradeIconBg = Color(0xFFE8F8EE);

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Scaffold(
      backgroundColor: dashBoardBgColor_(context),
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: controller.isLoading.value,
          opacity: 0,
          progressIndicator: const CustomProgressbar(),
          child: Visibility(
            visible: controller.isMainViewVisible.value,
            child: Column(
              children: [
                Expanded(
                  child: SafeArea(
                    bottom: false,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: [
                          UserCheckOutHeader(),
                          UserCheckOutTimesRow(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Obx(() {
                              final addressText =
                                  controller.addressController.value.text;
                              final tradeText =
                                  controller.tradeController.value.text;

                              return Column(
                                children: [
                                  UserCheckOutSummaryCard(),
                                  UserCheckOutInfoCard(
                                    iconPath: Drawable.checkinAddressIcon,
                                    iconBackgroundColor: _addressIconBg,
                                    title: 'address'.tr,
                                    subtitle: addressText,
                                  ),
                                  UserCheckOutInfoCard(
                                    iconPath: Drawable.checkinTradeIcon,
                                    iconBackgroundColor: _tradeIconBg,
                                    title: 'trade'.tr,
                                    subtitle: tradeText,
                                  ),
                                  UserCheckOutTaskSection(),
                                  // Visibility(
                                  //   visible: StringHelper.isEmptyString(
                                  //           controller.checkLogInfo.value
                                  //               .checkoutDateTime) &&
                                  //       (controller.checkLogInfo.value
                                  //                   .taskList ??
                                  //               [])
                                  //           .length ==
                                  //           1,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(top: 4),
                                  //     child: AddNoteWidget(
                                  //       controller: controller.noteController,
                                  //       borderRadius: 15,
                                  //       validator: MultiValidator([]),
                                  //     ),
                                  //   ),
                                  // ),
                                  // CheckInOutDisplayNoteWidget(
                                  //   note: controller
                                  //       .checkLogInfo.value.checkInNote,
                                  //   labelText: 'check_in_note'.tr,
                                  // ),
                                  // CheckInOutDisplayNoteWidget(
                                  //   note: controller
                                  //       .checkLogInfo.value.checkOutNote,
                                  //   labelText: 'check_out_note'.tr,
                                  // ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: StringHelper.isEmptyString(
                      controller.checkLogInfo.value.checkoutDateTime),
                  child: UserCheckOutFooter(
                    onPressed: controller.checkOutApi,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
