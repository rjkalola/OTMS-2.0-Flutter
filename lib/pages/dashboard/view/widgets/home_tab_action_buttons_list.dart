import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../res/colors.dart';
import '../../../../utils/app_utils.dart';
import '../../controller/dashboard_controller.dart';

class HomeTabActionButtonsList extends StatelessWidget {
  HomeTabActionButtonsList({super.key});

  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: double.infinity,
    //   height: 90,
    //   child: PageView.builder(
    //     // itemCount: dashboardController.listHeaderButtons_.length,
    //       itemCount: 0,
    //       onPageChanged: (int page) {
    //         dashboardController.selectedActionButtonPagerPosition.value = page;
    //       },
    //       itemBuilder: (context, index) {
    //         return GridView.count(
    //             physics: const NeverScrollableScrollPhysics(),
    //             crossAxisCount: 3,
    //             children: List.generate(
    //               // dashboardController.listHeaderButtons_[index].length,
    //               0,
    //                   (position) {
    //                 return InkWell(
    //                   child: Column(
    //                     children: [
    //                       Container(
    //                           padding: const EdgeInsets.all(14),
    //                           width: 80,
    //                           height: 54,
    //                           decoration: BoxDecoration(
    //                               shape: BoxShape.rectangle,
    //                               borderRadius: BorderRadius.circular(6),
    //                               color: Color(AppUtils.haxColor(
    //                                   dashboardController
    //                                       .listHeaderButtons_[index][position]
    //                                       .backgroundColor!))),
    //                           child: SvgPicture.asset(
    //                             dashboardController
    //                                 .listHeaderButtons_[index][position].image!,
    //                           )),
    //                       Padding(
    //                         padding: const EdgeInsets.only(top: 6),
    //                         child: Text(
    //                           dashboardController
    //                               .listHeaderButtons_[index][position].title!,
    //                           overflow: TextOverflow.ellipsis,
    //                           style: const TextStyle(
    //                             color: primaryTextColor,
    //                             fontWeight: FontWeight.w500,
    //                             fontSize: 15,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   onTap: () {
    //                     dashboardController
    //                         .onActionButtonClick(dashboardController
    //                         .listHeaderButtons_[index][position].id!);
    //                   },
    //                 );
    //               },
    //             ));
    //       }),
    // );
    return Container(width: double.infinity, height: 90, child: Text(""));
  }
}
