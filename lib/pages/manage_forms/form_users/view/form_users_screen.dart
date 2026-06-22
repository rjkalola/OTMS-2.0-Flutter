import 'package:belcka/pages/manage_forms/form_users/controller/form_users_controller.dart';
import 'package:belcka/pages/manage_forms/form_users/view/widgets/form_users_list_item.dart';
import 'package:belcka/pages/user_orders/widgets/empty_state_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FormUsersScreen extends StatefulWidget {
  const FormUsersScreen({super.key});

  @override
  State<FormUsersScreen> createState() => _FormUsersScreenState();
}

class _FormUsersScreenState extends State<FormUsersScreen> {
  final controller = Get.put(FormUsersController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Obx(
      () => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
          top: false,
          bottom: !GetPlatform.isIOS,
          child: Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: controller.screenTitle.value,
              isCenterTitle: false,
              isBack: true,
              bgColor: dashBoardBgColor_(context),
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                      onPressed: () {
                        controller.isInternetNotAvailable.value = false;
                        controller.fetchFormUsers();
                      },
                    )
                  : Visibility(
                      visible: controller.isMainViewVisible.value,
                      child: controller.formEntries.isEmpty
                          ? EmptyStateView(
                              title: 'no_data_found'.tr,
                              message: '',
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(top: 12, bottom: 16),
                              itemCount: controller.formEntries.length,
                              itemBuilder: (context, index) {
                                final entry = controller.formEntries[index];
                                return FormUsersListItem(
                                  entry: entry,
                                  onTap: () => controller.onUserTap(entry),
                                );
                              },
                            ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
