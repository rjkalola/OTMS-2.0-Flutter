import 'package:flutter/material.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';

class InfoTile extends StatelessWidget {
  final String title, value;
  final IconData iconData;

  const InfoTile(
      {required this.title, required this.value, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      borderRadius: 16,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // elevation: 2,
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: TextStyle(fontSize: 16)),
        leading: Icon(iconData),
      ),
    );
  }
}
