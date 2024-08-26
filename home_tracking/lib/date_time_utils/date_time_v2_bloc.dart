import 'package:bloc/bloc.dart';
import 'package:home_tracking/date_time_utils/param_date.dart';

import '../presentation/blocs/bloc_state.dart';
import 'model_local.dart';

class DateTimeV2Bloc extends Cubit<BlocState<ParamDate>> {
  DateTimeV2Bloc() : super(BlocState<ParamDate>());

  DateTime? _start;
  DateTime? _end;
  DateTime? get start => _start;
  DateTime? get end => _end;
  final DateTime _now = DateTime.now();

  final List<ModelLocal> optionYear = [
    ModelLocal(
      dateRange: DateRangeEnum.thisYear,
      value: 'Năm nay',
    ),
    ModelLocal(
      dateRange: DateRangeEnum.lastYear,
      value: 'Năm trước',
    ),
    ModelLocal(
      dateRange: DateRangeEnum.option,
      value: 'Tuỳ chọn',
    ),
  ];

  final List<ModelLocal> optionDateTime = [
    ModelLocal(
      dateRange: DateRangeEnum.today,
      value: 'Hôm nay',
    ),
    ModelLocal(
      dateRange: DateRangeEnum.yesterday,
      value: 'Hôm qua',
    ),
    ModelLocal(
      dateRange: DateRangeEnum.thisWeek,
      value: 'Tuần này',
    ),
    ModelLocal(
      dateRange: DateRangeEnum.thisMonth,
      value: 'Tháng này',
    ),
    ModelLocal(
      dateRange: DateRangeEnum.lastWeek,
      value: 'Tuần trước',
    ),
    ModelLocal(
      dateRange: DateRangeEnum.lastMonth,
      value: 'Tháng trước',
    ),
    ModelLocal(
      dateRange: DateRangeEnum.all,
      value: 'Tất cả',
    ),
    ModelLocal(
      dateRange: DateRangeEnum.option,
      value: 'Tuỳ chọn',
    ),
  ];

  back() {
    emit(
      state.copyWith(status: Status.initial),
    );
  }

  ParamDate chooseBtn(
      ModelLocal item, {
        DateTime? dateStart,
        DateTime? dateEnd,
      }) {
    if (item.dateRange == DateRangeEnum.today) {
      _start = DateTime(_now.year, _now.month, _now.day);
      _end = _now;
    } else if (item.dateRange == DateRangeEnum.yesterday) {
      _start = DateTime(_now.year, _now.month, _now.day - 1);
      _end = _start!.copyWith(
        hour: 23,
        minute: 59,
        second: 59,
      );
    } else if (item.dateRange == DateRangeEnum.thisWeek) {
      _getWeek(false);
    } else if (item.dateRange == DateRangeEnum.thisMonth) {
      _getMonth(false);
    } else if (item.dateRange == DateRangeEnum.lastWeek) {
      _getWeek(true);
    } else if (item.dateRange == DateRangeEnum.lastMonth) {
      _getMonth(true);
    } else {
      _start = null;
      _end = null;
    }
    if (dateStart != null && dateEnd != null) {
      _start = dateStart;
      _end = dateEnd;
    }
    final param = ParamDate(
      dateRange: item.dateRange,
      startDate: _start,
      endDate: _end,
    );

    emit(
      state.copyWith(
        status: Status.success,
        msg: item.value,
        data: param,
      ),
    );
    print('${item.dateRange} - ${item.value} - Start: $_start <==> End: $_end');

    return param;
  }

  _getWeek(bool isLast) {
    final int currentWeekday = _now.weekday;
    DateTime mondayWeek;
    DateTime sundayWeek;
    if (isLast) {
      mondayWeek = _now
          .subtract(Duration(days: currentWeekday + 6))
          .copyWith(hour: 0, minute: 0, second: 0);
      sundayWeek = _now
          .subtract(Duration(days: currentWeekday))
          .copyWith(hour: 23, minute: 59, second: 59);
    } else {
      mondayWeek = _now
          .subtract(
        Duration(days: currentWeekday - 1),
      )
          .copyWith(hour: 0, minute: 0, second: 0);
      sundayWeek = _now;
    }

    _start = mondayWeek;
    _end = sundayWeek;

    print('now: $_now');
    print('Monday of last week: $mondayWeek');
    print('Sunday of last week: $sundayWeek');
  }

  _getMonth(bool isLast) {
    DateTime firstDayMonth;
    DateTime lastDayMonth;

    if (isLast) {
      firstDayMonth = DateTime(_now.year, _now.month - 1, 1);
      lastDayMonth = DateTime(_now.year, _now.month, 0, 23, 59, 59);
    } else {
      firstDayMonth = DateTime(_now.year, _now.month, 1);
      lastDayMonth = _now;
    }

    _start = firstDayMonth;
    _end = lastDayMonth;

    print('now: $_now');
    print('First day month: $firstDayMonth');
    print('Last day month: $lastDayMonth');
  }
}