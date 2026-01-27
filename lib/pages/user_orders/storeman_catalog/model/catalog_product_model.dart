class CatalogProductModel{
  final String name;
  final String code;
  final double price;
  final int qty;
  final List<String> images;

  CatalogProductModel({
    required this.name,
    required this.code,
    required this.price,
    required this.qty,
    required this.images,
  });
}
