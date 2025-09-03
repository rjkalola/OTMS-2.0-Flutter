import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/authentication/other_info_steps/step2_business_field_info/controller/business_field_info_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/web_services/response/module_info.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';

class BusinessFieldInfoItemsList extends StatelessWidget {
  BusinessFieldInfoItemsList({
    super.key,
  });

  // final List<ModuleInfo> itemsList;
  // final ValueChanged<int> onViewClick;
  // final int selectedIndex;
  final controller = Get.put(BusinessFieldInfoController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(), //
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: List.generate(
            controller.listItems.length,
            (position) => GestureDetector(
              onTap: () {
                controller.selectedIndex.value = position;
                // controller.listItems[position].check =
                //     !(controller.listItems[position].check ?? false);
                // controller.listItems.refresh();
              },
              child: Container(
                margin: EdgeInsets.only(top: 6, bottom: 6),
                decoration: AppUtils.getDashboardItemDecoration(
                    borderWidth: 2,
                    borderColor: (controller.selectedIndex.value == position)
                        ? defaultAccentColor_(context)
                        : Colors.grey.shade300),
                padding: EdgeInsets.fromLTRB(16, 10, 14, 10),
                child: Row(
                  children: [
                    ImageUtils.setAssetsImage(
                        path: Drawable.constructionImage,
                        width: 30,
                        height: 30),
                    SizedBox(
                      width: 10,
                    ),
                    PrimaryTextView(
                      text: controller.listItems[position].name ?? "",
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      softWrap: true,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
