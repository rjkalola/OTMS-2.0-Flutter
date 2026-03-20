enum OrderTabType {
  request,
  upcoming,
  proceed,
  delivered,
  cancelled,
}

enum UserScoreType {
  warnings(1),
  kpi(2),
  appActivity(3);
  final int value;
  const UserScoreType(this.value);
}