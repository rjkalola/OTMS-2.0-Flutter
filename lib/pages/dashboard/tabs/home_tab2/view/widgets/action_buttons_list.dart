import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/dashboard/tabs/home_tab2/controller/home_tab_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';

class HomeTabActionButtonsList extends StatelessWidget {
  HomeTabActionButtonsList({super.key});

  final controller = Get.put(HomeTabController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      child: PageView.builder(
          itemCount: controller.listHeaderButtons_.length,
          onPageChanged: (int page) {
            controller.selectedActionButtonPagerPosition.value = page;
          },
          itemBuilder: (context, index) {
            return GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: List.generate(
                  controller.listHeaderButtons_[index].length,
                  (position) {
                    return InkWell(
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(14),
                              width: 80,
                              height: 54,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(6),
                                  color: Color(AppUtils.haxColor(controller
                                      .listHeaderButtons_[index][position]
                                      .backgroundColor!))),
                              child: SvgPicture.asset(
                                controller
                                    .listHeaderButtons_[index][position].image!,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              controller
                                  .listHeaderButtons_[index][position].title!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: primaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        controller.onActionButtonClick(
                            controller.listHeaderButtons_[index][position].id!);
                      },
                    );
                  },
                ));
          }),
    );
  }
}
