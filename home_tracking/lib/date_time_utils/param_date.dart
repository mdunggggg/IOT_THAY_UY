import 'package:home_tracking/shared/extension/ext_date_time.dart';

class ParamDate {
  DateTime? startDate;
  DateTime? endDate;
  DateRangeEnum? dateRange;
  ParamDate({
    this.dateRange = DateRangeEnum.thisMonth,
    this.endDate,
    this.startDate,
  });

  Map<String, dynamic> toJson() {
    return {
      if (startDate != null && dateRange == DateRangeEnum.option)
        'created_at__gte': startDate?.formatCustom(format: 'yyyy-MM-dd'),
      if (endDate != null && dateRange == DateRangeEnum.option)
        'created_at__lte': endDate.formatCustom(format: 'yyyy-MM-dd'),
      if (dateRange != null && dateRange != DateRangeEnum.option)
        'date_range': dateRange?.val,
    };
  }

  String toText() {
    return '$dateRange : $startDate : $endDate';
  }
}

enum DateRangeEnum {
  //["last_week", "this_week", "this_month", "last_month", "today", "yesterday"]

  option('option'),
  all('all'),
  today('today'),
  yesterday('yesterday'),
  thisWeek('this_week'),
  lastWeek('last_week'),
  thisMonth('this_month'),
  lastMonth('last_month'),
  lastYear('last_year'),
  thisYear('last_year');

  final String val;
  const DateRangeEnum(this.val);
}

extension DateRangeEnumExt on DateRangeEnum {
  String get toName => _convertName();

  String _convertName() {
    switch (this) {
      case DateRangeEnum.today:
        return 'Hôm nay';
      case DateRangeEnum.yesterday:
        return 'Hôm qua';
      case DateRangeEnum.thisWeek:
        return 'Tuần này';
      case DateRangeEnum.lastWeek:
        return 'Tuần trước';
      case DateRangeEnum.thisMonth:
        return 'Tháng này';
      case DateRangeEnum.lastMonth:
        return 'Tháng trước';
      case DateRangeEnum.thisYear:
        return 'Năm nay';
      case DateRangeEnum.lastYear:
        return 'Năm trước';
      case DateRangeEnum.option:
        return 'Tuỳ chọn';
      default:
        return 'Tất cả';
    }
  }
}
