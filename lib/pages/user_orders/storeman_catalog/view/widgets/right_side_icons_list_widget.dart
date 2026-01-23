import 'package:belcka/pages/user_orders/storeman_catalog/controller/storeman_catalog_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RightSideIconsListWidget extends StatelessWidget {
  RightSideIconsListWidget({super.key});

  final controller = Get.put(StoremanCatalogController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: const Color(0xFFDADADA),
      child: ListView.builder(
        itemCount: controller.sideIcons.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 22,
              child: Icon(controller.sideIcons[index], color: Colors.black54),
            ),
          );
        },
      ),
    );
  }
}