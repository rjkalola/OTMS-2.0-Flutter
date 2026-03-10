enum SupplierOrderStatus {
  all(0),
  upcoming(1),
  processing(2),
  onStock(3);

  final int value;
  const SupplierOrderStatus(this.value);
}
