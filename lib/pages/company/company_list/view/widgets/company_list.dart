import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/common/model/user_info.dart';
import 'package:belcka/pages/company/company_list/controller/company_list_controller.dart';
import 'package:belcka/pages/company/company_signup/model/company_info.dart';
import 'package:belcka/pages/company/switch_company/controller/switch_company_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/web_services/api_constants.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:belcka/widgets/switch/custom_switch.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

import '../../../../../utils/app_constants.dart';

class CompanyList extends StatelessWidget {
  CompanyList({super.key});

  final controller = Get.put(CompanyListController());

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
                        var arguments = {
                          AppConstants.intentKey.companyId: info.id ?? 0,
                        };
                        controller.moveToScreen(
                            AppRoutes.companyDetailsScreen, arguments);
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 9, 0, 9),
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
                            IconButton(
                                onPressed: () {
                                  controller.showDeleteTeamDialog(info.id ?? 0);
                                },
                                icon: ImageUtils.setSvgAssetsImage(
                                    path: Drawable.deleteIcon,
                                    color: Colors.red,
                                    width: 26,
                                    height: 26)),
                            // SizedBox(
                            //   width: 6,
                            // ),
                            // Visibility(
                            //   visible: ApiConstants.companyId != info.id,
                            //   child: CustomSwitch(
                            //       onValueChange: (value) {
                            //         info.isActiveCompany =
                            //             !(info.isActiveCompany ?? false);
                            //         controller.companyList.refresh();
                            //         controller
                            //             .showSwitchCompanyDialog(info.id ?? 0);
                            //       },
                            //       mValue: info.isActiveCompany ?? false),
                            // ),
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
