import 'package:belcka/pages/user_orders/categories/controller/user_orders_categories_repository.dart';
import 'package:belcka/pages/user_orders/categories/model/category_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserOrdersCategoriesController extends GetxController{
  RxBool isDeliverySelected = true.obs;
  final _api = UserOrdersCategoriesRepository();
  RxBool isLoading = false.obs,
      isInternetNotAvailable = false.obs,
      isMainViewVisible = true.obs,
      isSearchEnable = false.obs,
      isClearSearch = false.obs;

  final List<CategoryItem> categories = [
    CategoryItem("Appliances", Icons.kitchen),
    CategoryItem("Bathrooms", Icons.bathtub_outlined),
    CategoryItem("Cleaning", Icons.cleaning_services_outlined),
    CategoryItem("Doors & Windows", Icons.door_front_door_outlined),
    CategoryItem("External", Icons.house_outlined),
    CategoryItem("Flooring", Icons.grid_view_outlined),
    CategoryItem("General materials", Icons.construction_outlined),
    CategoryItem("Heating & Plumbing", Icons.water_damage_outlined),
    CategoryItem("Painting & Decoration", Icons.format_paint_outlined),
    CategoryItem("Radiators", Icons.heat_pump_outlined),
    CategoryItem("Screws, Nails & Fixing", Icons.hardware_outlined),
    CategoryItem("Sealants & Adhesives", Icons.build_outlined),
    CategoryItem("Security & Ironmongery", Icons.lock_outline),
    CategoryItem("Timber", Icons.forest_outlined),
    CategoryItem("Tools & Accessories", Icons.handyman_outlined),
  ];

}