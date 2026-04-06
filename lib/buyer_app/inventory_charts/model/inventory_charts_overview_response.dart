class InventoryChartsOverviewResponse {
  bool? isSuccess;
  String? message;
  String? startDate;
  String? endDate;
  String? currency;
  List<WeekDaysWiseBlock>? weekDaysWiseData;
  List<WeekWisePoint>? weekWiseData;

  InventoryChartsOverviewResponse({
    this.isSuccess,
    this.message,
    this.startDate,
    this.endDate,
    this.currency,
    this.weekDaysWiseData,
    this.weekWiseData,
  });

  InventoryChartsOverviewResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['message'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    currency = json['currency'];
    if (json['week_days_wise_data'] != null) {
      weekDaysWiseData = <WeekDaysWiseBlock>[];
      for (final v in json['week_days_wise_data'] as List) {
        weekDaysWiseData!.add(WeekDaysWiseBlock.fromJson(v as Map<String, dynamic>));
      }
    }
    if (json['week_wise_data'] != null) {
      weekWiseData = <WeekWisePoint>[];
      for (final v in json['week_wise_data'] as List) {
        weekWiseData!.add(WeekWisePoint.fromJson(v as Map<String, dynamic>));
      }
    }
  }
}

class WeekDaysWiseBlock {
  String? week;
  List<DayInOut>? days;

  WeekDaysWiseBlock({this.week, this.days});

  WeekDaysWiseBlock.fromJson(Map<String, dynamic> json) {
    week = json['week']?.toString();
    if (json['days'] != null) {
      days = <DayInOut>[];
      for (final v in json['days'] as List) {
        days!.add(DayInOut.fromJson(v as Map<String, dynamic>));
      }
    }
  }
}

class DayInOut {
  String? day;
  double inventoryIn;
  double inventoryOut;

  DayInOut({this.day, this.inventoryIn = 0, this.inventoryOut = 0});

  DayInOut.fromJson(Map<String, dynamic> json)
      : day = json['day']?.toString(),
        inventoryIn = _toDouble(json['in']),
        inventoryOut = _toDouble(json['out']);

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }
}

class WeekWisePoint {
  String? week;
  double inventoryIn;
  double inventoryOut;

  WeekWisePoint({this.week, this.inventoryIn = 0, this.inventoryOut = 0});

  WeekWisePoint.fromJson(Map<String, dynamic> json)
      : week = json['week']?.toString(),
        inventoryIn = DayInOut._toDouble(json['in']),
        inventoryOut = DayInOut._toDouble(json['out']);
}
