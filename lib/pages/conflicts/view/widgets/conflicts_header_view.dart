import 'package:belcka/pages/conflicts/view/widgets/conflicts_tab_bar.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:flutter/material.dart';

class ConflictsHeaderView extends StatelessWidget {
  const ConflictsHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          ConflictsTabBar(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
