enum OrderTabType {
  request,
  proceed,
  delivered,
}

enum UserScoreType {
  warnings(1),
  kpi(2),
  appActivity(3);
  final int value;
  const UserScoreType(this.value);
}