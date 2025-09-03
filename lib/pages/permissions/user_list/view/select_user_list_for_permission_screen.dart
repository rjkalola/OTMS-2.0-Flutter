import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/permissions/company_permissions/view/widgets/company_permissions_list.dart';
import 'package:belcka/pages/permissions/permission_users/controller/permission_users_controller.dart';
import 'package:belcka/pages/permissions/permission_users/view/widgets/permission_users_list.dart';
import 'package:belcka/pages/permissions/permission_users/view/widgets/search_permission_users.dart';
import 'package:belcka/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:belcka/pages/permissions/user_list/view/widgets/search_users.dart';
import 'package:belcka/pages/permissions/user_list/view/widgets/users_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/utils/app_utils.dart';
class SelectUserListForPermissionScreen extends StatefulWidget {
  const SelectUserListForPermissionScreen({super.key});

  @override
  State<SelectUserListForPermissionScreen> createState() =>
      _SelectUserListForPermissionScreenState();
}

class _SelectUserListForPermissionScreenState
    extends State<SelectUserListForPermissionScreen> {
  final controller = Get.put(UserListController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'users'.tr,
            isCenterTitle: false,
            isBack: true,
          ),
          body: Obx(() {
            return ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.getUserListApi();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            Divider(),
                            SearchUsersWidget(),
                            UsersList()
                          ],
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
