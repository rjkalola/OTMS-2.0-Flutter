import 'package:belcka/pages/manage_forms/forms_list/controller/forms_list_controller.dart';
import 'package:belcka/pages/manage_forms/forms_list/view/widgets/forms_list_item.dart';
import 'package:belcka/pages/user_orders/widgets/empty_state_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FormsListScreen extends StatefulWidget {
  const FormsListScreen({super.key});

  @override
  State<FormsListScreen> createState() => _FormsListScreenState();
}

class _FormsListScreenState extends State<FormsListScreen> {
  final controller = Get.put(FormsListController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || result != null) return;
        controller.onBackPress();
      },
      child: Obx(
        () => Container(
          color: dashBoardBgColor_(context),
          child: SafeArea(
            top: false,
            bottom: !GetPlatform.isIOS,
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'manage_forms'.tr,
                isCenterTitle: false,
                isBack: true,
                bgColor: dashBoardBgColor_(context),
                widgets: _actionButtons(context),
                isSearching: controller.isSearchEnable.value,
                searchController: controller.searchController,
                onValueChange: controller.searchItem,
                autoFocus: true,
                onPressedClear: controller.clearSearch,
                onBackPressed: () {
                  controller.onBackPress();
                },
              ),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ? NoInternetWidget(
                        onPressed: () {
                          controller.isInternetNotAvailable.value = false;
                          controller.fetchFormsList();
                        },
                      )
                    : Visibility(
                        visible: controller.isMainViewVisible.value,
                        child: Column(
                          children: [
                            const Divider(height: 1),
                            Expanded(
                              child: controller.formsList.isEmpty
                                  ? EmptyStateView(
                                      title: 'no_forms_found'.tr,
                                      message: 'no_forms_found_sub_msg'.tr,
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 16,
                                      ),
                                      clipBehavior: Clip.none,
                                      itemCount: controller.formsList.length,
                                      itemBuilder: (context, index) {
                                        final item =
                                            controller.formsList[index];
                                        return FormsListItem(
                                          item: item,
                                          fromStartWorkClick:
                                              controller.fromStartWorkClick,
                                          onTap: () =>
                                              controller.onFormTap(item),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget>? _actionButtons(BuildContext context) {
    return [
      Visibility(
        visible: !controller.isSearchEnable.value,
        child: InkWell(
          onTap: () {
            controller.isSearchEnable.value = true;
          },
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: ImageUtils.setSvgAssetsImage(
              path: Drawable.searchIcon,
              width: 24,
              height: 24,
              color: primaryTextColor_(context),
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
    ];
  }
}
