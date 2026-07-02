import 'package:belcka/pages/check_in/user_check_in/controller/user_check_in_controller.dart';
import 'package:belcka/pages/check_in/user_check_in/view/widgets/user_check_in_footer.dart';
import 'package:belcka/pages/check_in/user_check_in/view/widgets/user_check_in_header.dart';
import 'package:belcka/pages/check_in/user_check_in/view/widgets/user_check_in_selection_card.dart';
import 'package:belcka/pages/check_in/user_check_in/view/widgets/user_check_in_note_section.dart';
import 'package:belcka/pages/check_in/user_check_in/view/widgets/user_check_in_photos_before_section.dart';
import 'package:belcka/pages/check_in/user_check_in/view/widgets/user_check_in_task_section.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserCheckInScreen extends StatefulWidget {
  const UserCheckInScreen({super.key});

  @override
  State<UserCheckInScreen> createState() => _UserCheckInScreenState();
}

class _UserCheckInScreenState extends State<UserCheckInScreen> {
  final controller = Get.put(UserCheckInController());

  static const bool _showTaskSection = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.readNavigationArguments();
      }
    });
  }

  static const Color _addressIconBg = Color(0xFFE8F3FC);
  static const Color _tradeIconBg = Color(0xFFE8F8EE);

  void _onCheckInPressed() {
    if (controller.addressId == 0) {
      AppUtils.showToastMessage('empty_address_message'.tr);
      return;
    }
    if (!controller.isValidBeforePhotos()) {
      AppUtils.showToastMessage('take_photo_before_starting_job'.tr);
      return;
    }
    controller.checkInApi();
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Scaffold(
      backgroundColor: dashBoardBgColor_(context),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Obx(
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
                          child: UserCheckInHeaderBar(),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              children: [
                                const UserCheckInHeaderContent(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Obx(() {
                                    final addressText =
                                        controller.addressController.value.text;
                                    final tradeText =
                                        controller.tradeController.value.text;
                                    final hasAddress =
                                        controller.addressId != 0 &&
                                            !StringHelper.isEmptyString(
                                                addressText);

                                    return Column(
                                      children: [
                                        UserCheckInSelectionCard(
                                          iconPath: Drawable.checkinAddressIcon,
                                          iconBackgroundColor: _addressIconBg,
                                          title: hasAddress
                                              ? 'address'.tr
                                              : 'select_address'.tr,
                                          subtitle: hasAddress
                                              ? addressText
                                              : 'choose_site_address'.tr,
                                          isPlaceholder: !hasAddress,
                                          onTap:
                                              controller.showSelectAddressDialog,
                                        ),
                                        UserCheckInSelectionCard(
                                          iconPath: Drawable.checkinTradeIcon,
                                          iconBackgroundColor: _tradeIconBg,
                                          title: !StringHelper.isEmptyString(
                                                  tradeText)
                                              ? 'trade'.tr
                                              : 'select_trade'.tr,
                                          subtitle: !StringHelper.isEmptyString(
                                                  tradeText)
                                              ? tradeText
                                              : 'select_trade'.tr,
                                          isPlaceholder:
                                              StringHelper.isEmptyString(
                                                  tradeText),
                                          onTap:
                                              controller.showSelectTradeDialog,
                                        ),
                                        UserCheckInPhotosBeforeSection(),
                                        const UserCheckInNoteSection(),
                                        Visibility(
                                          visible: _showTaskSection,
                                          child: UserCheckInTaskSection(),
                                        ),
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
                UserCheckInFooter(onPressed: _onCheckInPressed),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
