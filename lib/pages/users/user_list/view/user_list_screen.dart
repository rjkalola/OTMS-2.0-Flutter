import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/users/user_list/controller/user_list_controller.dart';
import 'package:otm_inventory/pages/users/user_list/view/widgets/search_users.dart';
import 'package:otm_inventory/pages/users/user_list/view/widgets/users_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final controller = Get.put(UserListController());

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
            title: 'users'.tr,
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor,
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
