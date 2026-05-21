import 'package:belcka/pages/user_orders/product_info/controller/product_info_controller.dart';
import 'package:belcka/pages/user_orders/product_info/view/widgets/product_info_bullet_points_container.dart';
import 'package:belcka/pages/user_orders/product_info/view/widgets/product_info_description_container.dart';
import 'package:belcka/pages/user_orders/product_info/view/widgets/product_info_header_section.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductInfoContainer extends StatelessWidget {
  ProductInfoContainer({super.key});

  final controller = Get.put(ProductInfoController());

  @override
  Widget build(BuildContext context) {

    final product = controller.product.value;

    return CardViewDashboardItem(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ProductInfoHeaderSection(),
            const SizedBox(height: 20),
            _buildSectionTitle("Primary Details"),
            _buildInfoCard([
              _buildRow("Product name", product.shortName ?? ""),
              _buildRow("UUID", product.uuid ?? ""),
              if ((product.productCategories ?? "").isNotEmpty)
              _buildRow("Product category", product.productCategories ?? ""),
              //_buildRow("Buying Price", product.perUnitPrice ?? ""),
              //_buildRow("Market Price", product.marketPrice ?? ""),
              //_buildRow("Quantity", product.qty.toString()),
              if ((product.description ?? "").isNotEmpty)
              _buildFullWidthRow("Description", product.description ?? ""),
            ],context),
            const SizedBox(height: 20),

            if ((product.supplierName ?? "").isNotEmpty ||
                (product.supplierCode ?? "").isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Supplier Details"),
                _buildInfoCard([
                  if ((product.supplierName ?? "").isNotEmpty)
                    _buildRow("Supplier name", product.supplierName ?? ""),
                  if ((product.supplierCode ?? "").isNotEmpty)
                    _buildRow("Supplier code", product.supplierCode ?? ""),
                ],context),
                const SizedBox(height: 20),
              ],
            ),

            if ((product.height ?? "").isNotEmpty ||
                (product.weight ?? "").isNotEmpty ||
                (product.modelName ?? "").isNotEmpty ||
                (product.manufactureName ?? "").isNotEmpty)
            _buildSectionTitle("Other Info"),

            if ((product.height ?? "").isNotEmpty ||
                (product.weight ?? "").isNotEmpty ||
                (product.modelName ?? "").isNotEmpty ||
                (product.manufactureName ?? "").isNotEmpty)

            _buildInfoCard([
              if ((product.height ?? "").isNotEmpty)
              _buildRow("Height", product.height ?? ""),
              if ((product.weight ?? "").isNotEmpty)
              _buildRow("Weight", product.weight ?? ""),
              if ((product.modelName ?? "").isNotEmpty)
              _buildRow("Model", product.modelName ?? "" ),
              if ((product.manufactureName ?? "").isNotEmpty)
              _buildRow("Manufacture", product.manufactureName ?? ""),
            ],context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoCard(List<Widget> children, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRow(String label1, String value1) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: _buildValueTile(label1, value1)),
        ],
      ),
    );
  }

  Widget _buildFullWidthRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: _buildValueTile(label, value),
    );
  }

  Widget _buildValueTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      ],
    );
  }

}