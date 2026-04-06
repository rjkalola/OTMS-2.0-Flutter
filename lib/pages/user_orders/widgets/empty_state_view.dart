import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class EmptyStateView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const EmptyStateView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Icon(icon, size: 80, color: Colors.grey),
          Image.asset(
            "assets/images/img_empty_data.png",
            height: 40,
          ),
          SizedBox(height: 16),
          TitleTextView(
            text: title,
              fontSize: 15,
              fontWeight: FontWeight.w600
          ),
          SizedBox(height: 8),
          SubtitleTextView(
            text: message,
              fontSize:14
          )
        ],
      ),
    );
  }
}