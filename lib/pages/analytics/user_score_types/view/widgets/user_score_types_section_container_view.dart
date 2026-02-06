import 'package:belcka/pages/analytics/user_score_types/controller/user_score_types_controller.dart';
import 'package:belcka/pages/analytics/user_score_types/view/widgets/kpi_app_activity_grid_view.dart';
import 'package:belcka/pages/analytics/user_score_types/view/widgets/warnings_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserScoreTypesSectionContainerView extends StatelessWidget {
  UserScoreTypesSectionContainerView({super.key});

  final controller = Get.put(UserScoreTypesController());

  @override
  Widget build(BuildContext context) {
    final type = controller.userScoreType.value.value;
    if (type == 1){
      return WarningsListView();
    }
    else{
      return KpiAppActivityGridView();
    }
  }
}
