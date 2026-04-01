enum HireUserProductStatus {
  available(1),
  request(2),
  hired(3),
  inService(4);

  final int value;
  const HireUserProductStatus(this.value);
}
