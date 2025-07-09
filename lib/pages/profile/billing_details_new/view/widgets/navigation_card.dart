import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationCard extends StatelessWidget {
  final String label;
  final String value;

  const NavigationCard({this.label = "", required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // center the arrow vertically
        children: [
          Expanded(
            child: label.isEmpty
                ? Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black,
              ),
              softWrap: true,
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Color(0xff999999),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Align(
            alignment: Alignment.center, // ensures the arrow is centered
            child: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }
}