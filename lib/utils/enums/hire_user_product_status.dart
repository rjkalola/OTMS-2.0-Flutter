enum HireUserProductStatus {
  all(0),
  available(1),
  request(2),
  hired(3),
  cancelled(3);
  final int value;
  const HireUserProductStatus(this.value);
}
