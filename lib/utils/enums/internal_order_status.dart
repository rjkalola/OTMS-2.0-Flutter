enum InternalOrderStatus {
  newOrders(0),
  preparing(1),
  ready(2),
  collected(3);

  final int value;
  const InternalOrderStatus(this.value);
}
