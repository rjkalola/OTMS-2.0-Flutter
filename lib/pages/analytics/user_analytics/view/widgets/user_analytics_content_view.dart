import 'package:belcka/pages/analytics/user_analytics/controller/user_analytics_controller.dart';
import 'package:belcka/pages/analytics/user_analytics/view/widgets/animated_analytics_card.dart';
import 'package:belcka/pages/analytics/user_analytics/view/widgets/user_analytics_buttons_grid_widget.dart';
import 'package:belcka/pages/analytics/user_analytics/view/widgets/user_analytics_score_card.dart';
import 'package:belcka/pages/profile/my_account/full_screen_image_view/full_screen_image_view_screen.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/user_utils.dart';
import 'package:belcka/widgets/other_widgets/user_avtar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAnalyticsContentView extends StatelessWidget {
  UserAnalyticsContentView({super.key});

  final controller = Get.put(UserAnalyticsController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAnalyticsScoreCard(),
          SizedBox(height: 8,),
          UserAnalyticsButtonsGridWidget(),
          /*
          AnimatedAnalyticsCard(
            title: 'Score - 83%',
            values: [40, 55, 75, 45, 95, 60],
            gradientColors: [Color(0xFF42A5F5), Color(0xFF5C6BC0)],
          ),
          AnimatedAnalyticsCard(
            title: 'Check In',
            values: [40, 55, 75, 45, 95, 60],
            gradientColors: [Color(0xFF9F1A1C), Color(0xFF6D85FF)],
          )
          */
        ],
      ),
    );
  }
}
