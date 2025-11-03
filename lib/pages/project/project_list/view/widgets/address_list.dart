import 'package:belcka/pages/project/address_list/model/address_info.dart';
import 'package:belcka/pages/project/project_list/controller/project_list_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';
import '../../../../../utils/app_constants.dart';

class AddressList extends StatelessWidget {
  AddressList({super.key});

  final controller = Get.put(ProjectListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                AddressInfo info = controller.addressList[position];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                  child: CardViewDashboardItem(
                    padding: EdgeInsets.fromLTRB(16, 10, 13, 10),
                    child: InkWell(
                      onTap: () {
                        var arguments = {
                          AppConstants.intentKey.addressInfo: info,
                        };
                        controller.moveToScreen(
                            AppRoutes.addressDetailsScreen, arguments);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  info.name ?? "",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: primaryTextColor_(context)),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: null,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SubtitleTextView(
                                        text: info.startDate,
                                        fontSize: 16,
                                      ),
                                    ),
                                    TextViewWithContainer(
                                      text: info.progress ?? "",
                                      padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
                                      fontColor: Colors.white,
                                      fontSize: 13,
                                      boxColor: AppUtils.getStatusColor(
                                          info.statusInt ?? 0),
                                      borderRadius: 45,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: primaryTextColor_(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: controller.addressList.length,
              /* separatorBuilder: (context, position) => const Padding(
                    padding: EdgeInsets.only(left: 70, right: 16),
                    child: Divider(
                      height: 0,
                      color: dividerColor,
                      thickness: 2,
                    ),
                  )),*/
              separatorBuilder: (context, position) => Container()),
        ));
  }
}
