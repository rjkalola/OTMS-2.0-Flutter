import 'package:belcka/pages/check_in/user_check_out_copy/controller/user_check_out_copy_controller.dart';
import 'package:belcka/pages/check_in/user_check_out_copy/view/widgets/check_in_out_display_note_widget.dart';
import 'package:belcka/pages/check_in/user_check_out_copy/view/widgets/user_check_out_copy_footer.dart';
import 'package:belcka/pages/check_in/user_check_out_copy/view/widgets/user_check_out_copy_header.dart';
import 'package:belcka/pages/check_in/user_check_out_copy/view/widgets/user_check_out_copy_info_card.dart';
import 'package:belcka/pages/check_in/user_check_out_copy/view/widgets/user_check_out_copy_summary_card.dart';
import 'package:belcka/pages/check_in/user_check_out_copy/view/widgets/user_check_out_copy_task_section.dart';
import 'package:belcka/pages/check_in/user_check_out_copy/view/widgets/user_check_out_copy_times_row.dart';
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

class UserCheckOutCopyScreen extends StatefulWidget {
  const UserCheckOutCopyScreen({super.key});

  @override
  State<UserCheckOutCopyScreen> createState() => _UserCheckOutCopyScreenState();
}

class _UserCheckOutCopyScreenState extends State<UserCheckOutCopyScreen> {
  final controller = Get.put(UserCheckOutCopyController());

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
                    child: Column(
                      children: [
                        ColoredBox(
                          color: dashBoardBgColor_(context),
                          child: const UserCheckOutCopyHeaderBar(),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              children: [
                                const UserCheckOutCopyHeaderContent(),
                                UserCheckOutCopyTimesRow(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Obx(() {
                                    final addressText =
                                        controller.addressController.value.text;
                                    final tradeText =
                                        controller.tradeController.value.text;

                                    return Column(
                                      children: [
                                        UserCheckOutCopySummaryCard(),
                                        UserCheckOutCopyInfoCard(
                                          iconPath: Drawable.checkinAddressIcon,
                                          iconBackgroundColor: _addressIconBg,
                                          title: 'address'.tr,
                                          subtitle: addressText,
                                        ),
                                        UserCheckOutCopyInfoCard(
                                          iconPath: Drawable.checkinTradeIcon,
                                          iconBackgroundColor: _tradeIconBg,
                                          title: 'trade'.tr,
                                          subtitle: tradeText,
                                        ),
                                        UserCheckOutCopyTaskSection(),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: StringHelper.isEmptyString(
                      controller.checkLogInfo.value.checkoutDateTime),
                  child: UserCheckOutCopyFooter(
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
