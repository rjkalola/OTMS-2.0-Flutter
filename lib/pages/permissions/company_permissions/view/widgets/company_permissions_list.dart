import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/permission_info.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/controller/company_permission_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/other_widgets/widget_icon_view.dart';
import 'package:otm_inventory/widgets/switch/custom_switch.dart';
import 'package:otm_inventory/widgets/text/widget_title_text_view.dart';

class CompanyPermissionsList extends StatelessWidget {
  CompanyPermissionsList({super.key});

  final controller = Get.put(CompanyPermissionController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                PermissionInfo info =
                    controller.companyPermissionList[position];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 9, 16, 9),
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              WidgetIconView(
                                iconPath: info.icon,
                                iconColor: info.color,
                                isAdminWidget: info.isAdmin,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              WidgetTitleTextView(
                                text: info.name ?? "",
                                fontSize: 18,
                              )
                            ],
                          ),
                        ),
                        CustomSwitch(
                            onValueChange: (value) {
                              print("value:" + value.toString());
                              info.status = !info.status!;
                              controller.companyPermissionList.refresh();
                              controller.isDataUpdated.value = true;
                              controller.checkSelectAll();
                              // controller.changeCompanyPermissionStatusApi(
                              //     info.permissionId ?? 0, value);
                            },
                            mValue: info.status)
                      ],
                    ),
                  ),
                );
              },
              itemCount: controller.companyPermissionList.length,
              // separatorBuilder: (context, position) => const Padding(
              //   padding: EdgeInsets.only(left: 100),
              //   child: Divider(
              //     height: 0,
              //     color: dividerColor,
              //     thickness: 0.8,
              //   ),
              // ),
              separatorBuilder: (context, position) => const Padding(
                    padding: EdgeInsets.only(left: 70, right: 16),
                    child: Divider(
                      height: 0,
                      color: dividerColor,
                      thickness: 2,
                    ),
                  )),
        ));
  }
}
