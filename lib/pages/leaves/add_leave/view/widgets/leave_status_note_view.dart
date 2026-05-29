import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';

class LeaveStatusNoteView extends StatelessWidget {
  const LeaveStatusNoteView({
    super.key,
    required this.title,
    required this.note,
  });

  final String title;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: double.infinity,
          child: Text.rich(
            textAlign: TextAlign.start,
            TextSpan(
              style: TextStyle(
                color: primaryTextColor_(context),
                fontSize: 16,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: note,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
