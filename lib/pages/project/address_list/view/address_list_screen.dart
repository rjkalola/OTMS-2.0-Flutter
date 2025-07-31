import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/common/common_bottom_navigation_bar_widget.dart';
import 'package:otm_inventory/pages/project/address_list/controller/address_list_controller.dart';
import 'package:otm_inventory/pages/project/project_list/controller/project_list_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import '../../../../utils/app_constants.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  final controller = Get.put(AddressListController());

  Color getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      case 'Pending':
        return Colors.grey;
      default:
        return primaryTextColor_(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        color: dashBoardBgColor_(context),
        child: SafeArea(
            child: Scaffold(
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: 'addresses'.tr,
                isCenterTitle: false,
                bgColor: dashBoardBgColor_(context),
                isBack: true,
                widgets: actionButtons(),
                onBackPressed: () {
                  controller.onBackPress();
                },
              ),
              backgroundColor: dashBoardBgColor_(context),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: controller.isInternetNotAvailable.value
                    ?  Center(
                  child: Text('no_internet_text'.tr),
                )
                    : Column(
                      children: [Visibility(
                          visible: controller.isMainViewVisible.value,
                          child: Expanded(
                            child:ListView.builder(
                              itemCount: controller.addressList.length,
                              padding: const EdgeInsets.all(12),
                              itemBuilder: (context, index) {
                                final item = controller.addressList[index];
                                final status = item.statusText;
                                final percent = item.progress;
                                final color = getStatusColor(item.statusText ?? "");
                                return Stack(
                                  children: [
                                    // Card Background
                                    CardViewDashboardItem(
                                      margin: const EdgeInsets.only(top: 10, bottom: 16),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      child: InkWell(
                                        onTap: () {
                                          var arguments = {
                                            AppConstants.intentKey.addressInfo: item,
                                          };
                                          controller.moveToScreen(
                                              AppRoutes.addressDetailsScreen, arguments);
                                        } ,
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 4),
                                            // Address Text
                                            Expanded(
                                              child: Text(
                                                item.name ?? "",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // Percentage
                                            Text(
                                              '$percent',
                                              style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 16,
                                                color: primaryTextColor_(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Positioned Status Badge (Overlapping top-left)
                                    Positioned(
                                      left: 16,
                                      top: 0,
                                      child: Container(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          item.statusText ?? "",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                      )],
                    ),
              ),
              bottomNavigationBar: CommonBottomNavigationBarWidget(),
            )
        )
    )
    );
  }

  List<Widget>? actionButtons() {
    return [
      SizedBox(width: 10),
      Visibility(
        visible: true,
        child: IconButton(
          icon: Icon(Icons.more_vert_outlined),
          onPressed: () {
            controller.showMenuItemsDialog(Get.context!);
          },
        ),
      ),
    ];
  }
}