import 'package:belcka/pages/analytics/score_more_details/controller/score_more_details_controller.dart';
import 'package:belcka/pages/analytics/score_more_details/view/score_more_details_header_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/custom_views/no_internet_widgets.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ScoreMoreDetailsScreen extends StatefulWidget {
  const ScoreMoreDetailsScreen({super.key});

  @override
  State<ScoreMoreDetailsScreen> createState() => _ScoreMoreDetailsScreenState();
}

class _ScoreMoreDetailsScreenState extends State<ScoreMoreDetailsScreen> {
  final controller = Get.put(ScoreMoreDetailsController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();

    return Container(
      color: backgroundColor_(context),
      child: SafeArea(
        child: Obx(
              () => Scaffold(
            backgroundColor: dashBoardBgColor_(context),
            appBar: BaseAppBar(
              appBar: AppBar(),
              title: 'more_details'.tr,
              isCenterTitle: false,
              isBack: true,
              bgColor: backgroundColor_(context),
            ),
            body: ModalProgressHUD(
              inAsyncCall: controller.isLoading.value,
              opacity: 0,
              progressIndicator: const CustomProgressbar(),
              child: controller.isInternetNotAvailable.value
                  ? NoInternetWidget(
                onPressed: () {
                  controller.isInternetNotAvailable.value = false;
                },
              )
                  : controller.isMainViewVisible.value
                  ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScoreMoreDetailsHeaderView(),
                    SizedBox(height: 16),
                    Center(
                      child: TitleTextView(
                        text: "What does this score mean?",
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8),
                    ScoreMeaningCard(score: controller.userScore ?? 0),
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

class ScoreMeaningCard extends StatelessWidget {
  final int score;
  const ScoreMeaningCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CardViewDashboardItem(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Score",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$score%",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),
            _ScoreScaleBox(),
          ],
        ),
      ),
    );
  }
}

class _ScoreScaleBox extends StatelessWidget {
  const _ScoreScaleBox();

  static const double rowHeight = 44;
  static const int itemCount = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: rowHeight * itemCount,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2ECC71),
                Color(0xFFF1C40F),
                Color(0xFFF7CE45),
                Color(0xFFFF0000),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _ScaleItem("Excellent 90-100"),
            _ScaleItem("Good 50-89"),
            _ScaleItem("Fair 30-49"),
            _ScaleItem("Need attention 20-29"),
            _ScaleItem("Contact to HR"),
          ],
        ),
      ],
    );
  }
}

class _ScaleItem extends StatelessWidget {
  final String text;
  const _ScaleItem(this.text);

  static const double rowHeight = 44;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: rowHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 18,
            height: 2,
            color: primaryTextColor_(context),
          ),
          const SizedBox(width: 10),
          // TEXT
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}