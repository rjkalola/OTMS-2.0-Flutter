import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/web_services/response/module_info.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class TeamUsersCountItemsList extends StatelessWidget {
  const TeamUsersCountItemsList(
      {super.key,
      required this.itemsList,
      required this.onViewClick,
      required this.selectedIndex});

  final List<ModuleInfo> itemsList;
  final ValueChanged<int> onViewClick;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: MasonryGridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  onViewClick(index);
                },
                child: Container(
                  decoration: AppUtils.getDashboardItemDecoration(
                      borderWidth: 2,
                      borderColor: (selectedIndex == index)
                          ? defaultAccentColor
                          : Colors.grey.shade300),
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: PrimaryTextView(
                      text: itemsList[index].name ?? "",
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      softWrap: true,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
