import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/controller/dashboard_controller.dart';
import 'package:otm_inventory/widgets/card_view.dart';
import '../../../../../res/colors.dart';
import '../../../../utils/app_utils.dart';

class HomeTabHeaderButtonsList extends StatelessWidget {
  HomeTabHeaderButtonsList({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    // return Obx(() => ListView(
    //       physics: const NeverScrollableScrollPhysics(), //
    //       shrinkWrap: true,
    //       scrollDirection: Axis.vertical,
    //       children: List.generate(
    //         // dashboardController.listHeaderButtons.length,
    //         0,
    //         (position) => InkWell(
    //           onTap: () {
    //             // dashboardController.onActionButtonClick(
    //             //     dashboardController.listHeaderButtons[position].id!);
    //           },
    //           child: CardView(
    //               child: Padding(
    //             padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
    //             child: Row(children: [
    //               Container(
    //                   padding: const EdgeInsets.all(14),
    //                   width: 80,
    //                   height: 54,
    //                   decoration: BoxDecoration(
    //                       shape: BoxShape.rectangle,
    //                       borderRadius: BorderRadius.circular(6),
    //                       color: Color(AppUtils.haxColor(dashboardController
    //                           .listHeaderButtons[position].backgroundColor!))),
    //                   child: SvgPicture.asset(
    //                     dashboardController.listHeaderButtons[position].image!,
    //                   )),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 16),
    //                 child: Text(
    //                   dashboardController.listHeaderButtons[position].title!,
    //                   overflow: TextOverflow.ellipsis,
    //                   style: const TextStyle(
    //                     color: primaryTextColor_(context),
    //                     fontWeight: FontWeight.w500,
    //                     fontSize: 17,
    //                   ),
    //                 ),
    //               ),
    //             ]),
    //           )),
    //         ),
    //       ),
    //     ));
    return Container(width: double.infinity, height: 90, child: Text(""));
  }
}
