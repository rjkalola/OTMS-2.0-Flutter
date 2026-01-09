class OrderInfo {
  final int id;
  final String name;
  final String sku;
  final String image;
  final int availableQty;
  final String projectName;
  final String userName;
  final double price;
  int qty;

  OrderInfo({
    required this.id,
    required this.name,
    required this.sku,
    required this.image,
    required this.availableQty,
    required this.projectName,
    required this.userName,
    required this.price,
    required this.qty,
  });

  double get totalPrice => price * qty;

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      image: json['image'] ?? '',
      availableQty: json['available_qty'] ?? 0,
      projectName: json['project_name'] ?? '',
      userName: json['user_name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      qty: json['qty'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'image': image,
      'available_qty': availableQty,
      'project_name': projectName,
      'user_name': userName,
      'price': price,
      'qty': qty,
    };
  }
}