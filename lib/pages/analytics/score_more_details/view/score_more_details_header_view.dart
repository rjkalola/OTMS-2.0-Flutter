import 'package:belcka/pages/analytics/score_more_details/controller/score_more_details_controller.dart';
import 'package:belcka/pages/analytics/user_score/view/widgets/user_score_warning_indicator_widget.dart';
import 'package:belcka/pages/analytics/user_score_types/controller/user_score_types_controller.dart';
import 'package:belcka/pages/analytics/user_score_types/view/widgets/user_score_types_header.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScoreMoreDetailsHeaderView extends StatelessWidget {
  ScoreMoreDetailsHeaderView({super.key});

  final controller = Get.put(ScoreMoreDetailsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Column(
        children: [

        ],
      ),
    );
  }
}
