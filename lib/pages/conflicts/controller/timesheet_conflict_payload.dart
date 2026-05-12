import 'package:belcka/pages/conflicts/model/conflicts_response.dart';

int? _timeToMinutes(String? t) {
  if (t == null || t.trim().isEmpty) return null;
  final parts = t.trim().split(':');
  if (parts.length < 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  return h * 60 + m;
}

(int, int)? timesheetIntervalTuple(ConflictItem item) {
  final s = _timeToMinutes(item.start);
  var e = _timeToMinutes(item.end);
  if (s == null || e == null) return null;
  if (e < s) e = s;
  return (s, e);
}

bool strictlyInside(int outerS, int outerE, int innerS, int innerE) {
  return outerS < innerS && innerE < outerE;
}

(ConflictItem outer, ConflictItem inner, int point)? splitOuterInner(
    ConflictItem a, ConflictItem b) {
  final pa = timesheetIntervalTuple(a);
  final pb = timesheetIntervalTuple(b);
  if (pa == null || pb == null) return null;
  final (ts1, te1) = pa;
  final (ts2, te2) = pb;
  if (strictlyInside(ts1, te1, ts2, te2) && te2 == ts2) {
    return (a, b, ts2);
  }
  if (strictlyInside(ts2, te2, ts1, te1) && te1 == ts1) {
    return (b, a, ts1);
  }
  return null;
}

String formatClockHHmm(int totalMinutes) {
  final m = totalMinutes.clamp(0, 24 * 60 - 1);
  final h = m ~/ 60;
  final min = m % 60;
  return "${h.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}";
}

String _durationHHmm(int startM, int endM) {
  final d = (endM - startM).clamp(0, 24 * 60);
  final h = d ~/ 60;
  final min = d % 60;
  return "${h.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}";
}

String _durationLabelMinutes(int startM, int endM) {
  final d = (endM - startM).clamp(0, 24 * 60);
  return "${d}m";
}

int _userId(ConflictItem a, ConflictItem b, UserConflictData data) {
  return a.userId ?? b.userId ?? data.userId ?? 0;
}

/// Same-start cut: trim longer worklog after shorter ends; shorter row unchanged.
List<Map<String, dynamic>>? buildCutDataList(
  UserConflictData data,
  ConflictItem a,
  ConflictItem b,
) {
  final pa = timesheetIntervalTuple(a);
  final pb = timesheetIntervalTuple(b);
  if (pa == null || pb == null) return null;
  var (ts1, te1) = pa;
  var (ts2, te2) = pb;
  if (ts1 != ts2) return null;

  final ConflictItem shorter;
  final ConflictItem longer;
  if (te1 <= te2) {
    shorter = a;
    longer = b;
  } else {
    shorter = b;
    longer = a;
  }
  final ps = timesheetIntervalTuple(shorter)!;
  final pl = timesheetIntervalTuple(longer)!;
  final shortStart = ps.$1;
  final shortEnd = ps.$2;
  final longEnd = pl.$2;
  final sid = shorter.worklogId;
  final lid = longer.worklogId;
  if (sid == null || lid == null) return null;

  final uid = _userId(a, b, data);
  if (uid == 0) return null;
  return [
    {
      "user_id": uid,
      "worklog_id": lid,
      "start_time": formatClockHHmm(shortEnd),
      "end_time": formatClockHHmm(longEnd),
      "total_time": _durationHHmm(shortEnd, longEnd),
    },
    {
      "user_id": uid,
      "worklog_id": sid,
      "start_time": formatClockHHmm(shortStart),
      "end_time": formatClockHHmm(shortEnd),
      "total_time": _durationHHmm(shortStart, shortEnd),
    },
  ];
}

List<Map<String, dynamic>>? buildSplitDataList(
  UserConflictData data,
  ConflictItem a,
  ConflictItem b,
) {
  final triplet = splitOuterInner(a, b);
  if (triplet == null) return null;
  final (outer, inner, point) = triplet;
  final po = timesheetIntervalTuple(outer);
  if (po == null) return null;
  final (os, oe) = po;
  final uid = _userId(a, b, data);
  if (uid == 0) return null;
  final date = outer.date ?? data.date ?? "";
  final formatted = data.formattedDate ?? "";
  final shiftName = outer.shiftName ?? "Shift";
  final shiftId = outer.shiftId ?? 0;

  return [
    {
      "user_id": uid,
      "worklog_id": outer.worklogId ?? 0,
      "shift_name": shiftName,
      "shift_id": shiftId,
      "date": date,
      "formatted_date": formatted,
      "start": formatClockHHmm(os),
      "end": formatClockHHmm(point),
      "total": _durationLabelMinutes(os, point),
    },
    {
      "user_id": uid,
      "worklog_id": inner.worklogId ?? 0,
      "shift_name": (inner.isLeave == true)
          ? (inner.leaveName ?? inner.shiftName ?? shiftName)
          : (inner.shiftName ?? shiftName),
      "shift_id": inner.shiftId ?? shiftId,
      "date": inner.date ?? date,
      "formatted_date": formatted,
      "start": formatClockHHmm(point),
      "end": formatClockHHmm(point),
      "total": "0m",
    },
    {
      "user_id": uid,
      "worklog_id": 0,
      "shift_name": shiftName,
      "shift_id": shiftId,
      "date": date,
      "formatted_date": formatted,
      "start": formatClockHHmm(point),
      "end": formatClockHHmm(oe),
      "total": _durationLabelMinutes(point, oe),
    },
  ];
}
