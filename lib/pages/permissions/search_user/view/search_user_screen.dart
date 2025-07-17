import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/permissions/search_user/controller/search_user_controller.dart';
import 'package:otm_inventory/pages/permissions/search_user/view/widgets/search_users.dart';
import 'package:otm_inventory/pages/permissions/search_user/view/widgets/users_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/custom_views/no_internet_widgets.dart';
import 'package:otm_inventory/utils/app_utils.dart';
class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<SearchUserScreen> {
  final controller = Get.put(SearchUserController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor_(context),
          appBar: AppBar(
              backgroundColor: Colors.white,
              title: SearchUsersWidget(),
              titleSpacing: 0,
              centerTitle: false,
              // titleSpacing: isBack ? 0 : 20,
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 20,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              scrolledUnderElevation: 0),
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
                          children: [Divider(), UsersList()],
                        ),
                      ));
          }),
        ),
      ),
    );
  }
}
