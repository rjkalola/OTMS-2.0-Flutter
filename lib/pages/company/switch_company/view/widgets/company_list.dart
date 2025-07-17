import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/company/company_signup/model/company_info.dart';
import 'package:otm_inventory/pages/company/switch_company/controller/switch_company_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/web_services/api_constants.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/switch/custom_switch.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class CompanyList extends StatelessWidget {
  CompanyList({super.key});

  final controller = Get.put(SwitchCompanyController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                CompanyInfo info = controller.companyList[position];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(9, 4, 9, 4),
                  child: CardViewDashboardItem(
                    child: GestureDetector(
                      onTap: () {
                        // var arguments = {
                        //   AppConstants.intentKey.userId: info.id ?? 0,
                        //   AppConstants.intentKey.userName: info.name ?? "",
                        //   AppConstants.intentKey.userList: controller.usersList,
                        // };
                        // Get.toNamed(AppRoutes.userPermissionScreen,
                        //     arguments: arguments);
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            UserAvtarView(
                              imageUrl: info.companyThumbImage ?? "",
                              imageSize: 52,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryTextView(
                                    text: info.name ?? "",
                                    fontSize: 17,
                                    color: primaryTextColor_(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Visibility(
                                    visible: ApiConstants.companyId == info.id,
                                    child: PrimaryTextView(
                                      text: 'active'.tr,
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Visibility(
                              visible: ApiConstants.companyId != info.id,
                              child: CustomSwitch(
                                  onValueChange: (value) {
                                    info.isActiveCompany =
                                        !(info.isActiveCompany ?? false);
                                    controller.companyList.refresh();
                                    controller
                                        .showSwitchCompanyDialog(info.id ?? 0);
                                  },
                                  mValue: info.isActiveCompany ?? false),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: controller.companyList.length,
              // separatorBuilder: (context, position) => const Padding(
              //   padding: EdgeInsets.only(left: 100),
              //   child: Divider(
              //     height: 0,
              //     color: dividerColor,
              //     thickness: 0.8,
              //   ),
              // ),
              separatorBuilder: (context, position) => Container()),
        ));
  }
}
