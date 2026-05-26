enum OrderStatus { completed, returned, cancelled, pending }

class MaterialOrder {
  final String orderId;
  final OrderStatus status;
  final double amount;
  final DateTime date;
  final String address;
  final String user;
  final int itemsDelivered;
  final int itemsTotal;

  const MaterialOrder({
    required this.orderId,
    required this.status,
    required this.amount,
    required this.date,
    required this.address,
    required this.user,
    required this.itemsDelivered,
    required this.itemsTotal,
  });
}
