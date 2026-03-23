enum SupplierOrderStatus {
  all(0),
  upcoming(1),
  processing(2),
  onStock(3),
  cancelled(4);

  final int value;
  const SupplierOrderStatus(this.value);
}
