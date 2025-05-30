import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab/model/permission_info.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/controller/company_permission_controller.dart';
import 'package:otm_inventory/pages/trades/controller/trades_controller.dart';
import 'package:otm_inventory/pages/trades/view/widgets/company_sub_trade_list.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/switch/custom_switch.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

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
                  padding: const EdgeInsets.fromLTRB(16, 9, 16, 9),
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(9),
                                width: 44,
                                height: 44,
                                decoration: AppUtils.getGrayBorderDecoration(
                                    color: backgroundColor,
                                    borderColor: dividerColor,
                                    borderWidth: 1),
                                child: ImageUtils.setSvgAssetsImage(
                                    path:
                                        "${AppConstants.permissionIconsAssetsPath}${info.icon ?? ""}",
                                    // path: Drawable.truckPermissionIcon,
                                    width: 26,
                                    height: 26,
                                    color: Color(AppUtils.haxColor(
                                        info.color ?? "#000000"))),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                info.name ?? "",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 17,
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        CustomSwitch(
                            onValueChange: (value) {
                              print("value:" + value.toString());
                              info.status = !info.status!;
                              controller.companyPermissionList.refresh();
                              controller.changeCompanyPermissionStatusApi(
                                  info.permissionId ?? 0, value);
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
