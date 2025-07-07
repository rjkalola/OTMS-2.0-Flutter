import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:otm_inventory/pages/profile/my_account/controller/my_account_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/widgets/other_widgets/user_avtar_view.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class MenuButtonsGridWidget extends StatelessWidget {
  MenuButtonsGridWidget({super.key});

  final controller = Get.put(MyAccountController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.menuItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 3 / 1.3,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                Get.toNamed(AppRoutes.billingDetailsNewScreen);
              }
              else if (index == 3) {
                Get.toNamed(AppRoutes.myRequestsScreen);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 8,offset: Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Icon(controller.menuItems[index]['icon'], color: Colors.blue,size: 28,weight: 100,),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryTextView(
                      text: controller.menuItems[index]['title'],
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      textAlign: TextAlign.center,
                      color: primaryTextColorLight,
                      softWrap: true,
                      maxLine: 2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}