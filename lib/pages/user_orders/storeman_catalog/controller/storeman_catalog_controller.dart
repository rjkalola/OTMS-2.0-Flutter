import 'package:get/get.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/catalog_product_model.dart';
import 'package:flutter/material.dart';

class StoremanCatalogController extends GetxController{

  RxBool isDeliverySelected = true.obs;
  //final _api = OrderHistoryRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  final List<CatalogProductModel> products = [
    CatalogProductModel(
      name: "ElectriQ 60cm 4 Zone Induction Hob",
      code: "DCK1234",
      price: 500.00,
      qty: 10,
      images: [
        "https://via.placeholder.com/300/000000/FFFFFF?text=Image+1",
        "https://via.placeholder.com/300/808080/FFFFFF?text=Image+2",
        "https://via.placeholder.com/300/cccccc/000000?text=Image+3",
      ],
    ),
    CatalogProductModel(
      name: "ElectriQ 60cm 4 Zone Induction Hob",
      code: "DCK1234",
      price: 120.00,
      qty: 10,
      images: [
        "https://via.placeholder.com/300/ff0000/FFFFFF?text=Image+1",
        "https://via.placeholder.com/300/ffa500/FFFFFF?text=Image+2",
      ],
    ),
    CatalogProductModel(
      name: "Twyford Alcona exposed cistern.",
      code: "DCK1234",
      price: 500.00,
      qty: 10,
      images: [
        "https://via.placeholder.com/300/00ff00/FFFFFF?text=Image+1",
        "https://via.placeholder.com/300/008000/FFFFFF?text=Image+2",
      ],
    ),
  ];

  final List<IconData> sideIcons = const [
    Icons.grid_view,
    Icons.kitchen,
    Icons.chair,
    Icons.light,
    Icons.bathtub,
    Icons.dining,
    Icons.ac_unit,
    Icons.water_drop,
    Icons.wifi,
    Icons.settings,
  ];

  final Map<int, int> currentImageIndex = {};
  @override
  void onInit() {
    super.onInit();

  }
}