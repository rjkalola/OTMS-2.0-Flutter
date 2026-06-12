class FormDateValue {
  FormDateValue({this.date, this.time});

  DateTime? date;
  DateTime? time;

  bool isComplete({
    required bool includeDate,
    required bool includeTime,
  }) {
    if (includeDate && date == null) return false;
    if (includeTime && time == null) return false;
    return includeDate || includeTime;
  }
}
