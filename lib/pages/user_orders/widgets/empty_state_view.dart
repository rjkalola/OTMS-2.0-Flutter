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
            height: 80,
          ),
          SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(message, style: TextStyle(fontSize:16,color: Colors.grey.shade600,)),
        ],
      ),
    );
  }
}