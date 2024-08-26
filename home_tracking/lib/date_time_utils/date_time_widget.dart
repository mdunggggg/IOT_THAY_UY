import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_tracking/date_time_utils/param_date.dart';
import 'package:home_tracking/presentation/blocs/bloc_state.dart';
import 'package:home_tracking/shared/extension/ext_context.dart';
import 'package:home_tracking/shared/extension/ext_num.dart';

import '../presentation/constants/colors.dart';
import '../presentation/constants/spacing.dart';
import '../presentation/constants/typography.dart';
import '../shared/colors/colors.dart';
import 'button.dart';
import 'date_time_v2_bloc.dart';
import 'grid_view_custome.dart';

enum TypeDate {
  year,
  month,
  day,
}

class DateTimeWidget extends StatefulWidget {
  ParamDate? param;
  TypeDate type;
  DateTimeWidget({
    this.param,
    this.type = TypeDate.day,
  });
  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  final bloc = DateTimeV2Bloc();

  List<DateTime?> dialogCalendarPickerValue = [null, null];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.param != null) {
      final option =
      widget.type == TypeDate.year ? bloc.optionYear : bloc.optionDateTime;
      final data = option
          .where((element) => element.dateRange == widget.param!.dateRange)
          .toList();
      if (data.isNotEmpty) {
        bloc.chooseBtn(
          data.first,
          dateStart: widget.param!.startDate,
          dateEnd: widget.param!.endDate,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: sp16.padding,
      shape: RoundedRectangleBorder(
        borderRadius: sp8.radius,
      ),
      child: BlocConsumer<DateTimeV2Bloc, BlocState<ParamDate>>(
        bloc: bloc,
        listener: (context, state) {
          if (state.status == Status.success &&
              state.data?.dateRange != DateRangeEnum.option) {
            context.pop(
              result: state.data,
            );
          }
        },
        builder: (context, state) {
          final bool isOption = state.status == Status.success &&
              state.data?.dateRange == DateRangeEnum.option;

          return Container(
            padding: !isOption ? sp16.padding : null,
            width: context.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isOption) ...[
                  const Text(
                    'Lọc thời gian',
                    style: p5,
                  ),
                  sp16.height,
                  _optionDateTime(),
                ],
                if (isOption) ...[
                  _toolBar(state),
                  if (widget.type == TypeDate.day) _datetimeChoose(state),
                  if (widget.type == TypeDate.year) _yearChoose(state),
                  if (widget.type == TypeDate.day)
                    Padding(
                      padding: sp16.paddingHor,
                      child: Row(
                        children: [
                          Expanded(
                            child: Extrabutton(
                              title: 'Huỷ bỏ',
                              event: () {
                                bloc.back();
                              },
                              largeButton: true,
                              borderColor: borderColor_2,
                              icon: null,
                            ),
                          ),
                          sp16.width,
                          Expanded(
                            child: MainButton(
                              title: 'Áp dụng',
                              event: () {
                                state.data?.startDate =
                                    dialogCalendarPickerValue.first;
                                state.data?.endDate =
                                    dialogCalendarPickerValue.last;
                                print(state.data?.toJson());
                                if(state.data?.startDate == state.data?.endDate){
                                  state.data?.endDate = state.data?.endDate?.add(const Duration(hours: 23, minutes: 59, seconds: 59));
                                }
                                context.pop(
                                  result: state.data,
                                );
                              },
                              largeButton: true,
                              icon: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  sp16.height,
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _yearChoose(BlocState<ParamDate> state) {
    final DateTime now = DateTime.now();
    const int length = 100;

    return Container(
      height: context.height * 0.3,
      padding: sp16.padding,
      child: GridViewCustom(
        padding: EdgeInsets.zero,
        showFull: true,
        shrinkWrap: true,
        mainAxisExtent: 37,
        maxWight: 60,
        crossAxisSpacing: sp8,
        mainAxisSpacing: sp8,
        itemBuilder: (context, index) {
          final bool isCheck =
              (now.year - index) == bloc.state.data?.startDate?.year;
          return GestureDetector(
            onTap: () {
              state.data?.startDate = now.copyWith(year: now.year - index);
              state.data?.endDate = now.copyWith(year: now.year - index);
              print(state.data?.toJson());

              context.pop(
                result: state.data,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: isCheck ? mainColor : ColorApp.white,
                borderRadius: sp8.radius,
                border: Border.all(
                  color: isCheck ? mainColor : ColorApp.greyF2,
                  width: 0.5,
                ),
              ),
              alignment: Alignment.center,
              padding: sp16.paddingHor,
              child: Text(
                '${now.year - index}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: p5.copyWith(
                  color: isCheck ? ColorApp.white : blackColor,
                ),
              ),
            ),
          );
        },
        itemCount: length,
      ),
    );
  }

  Widget _datetimeChoose(BlocState<ParamDate> state) {
    dialogCalendarPickerValue = [
      state.data?.startDate,
      state.data?.endDate,
    ];

    return CalendarDatePicker2(
      onValueChanged: (dates) {
        dialogCalendarPickerValue = dates;
      },
      value: dialogCalendarPickerValue,
      config: CalendarDatePicker2Config(
        weekdayLabels: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
        weekdayLabelTextStyle: p5.copyWith(color: borderColor_4),
        calendarType: CalendarDatePicker2Type.range,
        disableMonthPicker: true,
        dayBorderRadius: sp4.radius,
        lastDate: DateTime.now(),
        dayTextStyle: p5,
        selectedDayHighlightColor: mainColor,
        selectedRangeHighlightColor: accentColor_3.withOpacity(0.15),
        selectedRangeDayTextStyle: p5.copyWith(color: mainColor),
        modePickerTextHandler: ({isMonthPicker , required monthDate}) =>
        'Tháng ${monthDate.month} năm ${monthDate.year}',
        calendarViewMode: CalendarDatePicker2Mode.day,
        centerAlignModePicker: true,
        controlsTextStyle: p6.copyWith(fontSize: 16, color: blackColor),
        firstDayOfWeek: 1,
        nextMonthIcon: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor_2),
            borderRadius: sp4.radius,
          ),
          child: const Icon(
            Icons.east_rounded,
            size: 15,
            color: blackColor,
          ),
        ),
        lastMonthIcon: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor_2),
            borderRadius: sp4.radius,
          ),
          child: const Icon(
            Icons.west_rounded,
            size: 15,
            color: blackColor,
          ),
        ),
        allowSameValueSelection: true,
        customModePickerIcon: const SizedBox(),
        controlsHeight: 50,
      ),
    );
  }

  GridViewCustom _optionDateTime() {
    final option =
    widget.type == TypeDate.year ? bloc.optionYear : bloc.optionDateTime;
    return GridViewCustom(
      padding: EdgeInsets.zero,
      showFull: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisExtent: 37,
      crossAxisSpacing: sp8,
      crossAxisCount: 2,
      mainAxisSpacing: sp8,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          bloc.chooseBtn(option[index]);
        },
        child: Container(
          decoration: BoxDecoration(
            color: borderColor_1,
            borderRadius: sp8.radius,
            border: option[index].dateRange == bloc.state.data?.dateRange
                ? Border.all(color: mainColor)
                : null,
          ),
          alignment: Alignment.centerLeft,
          padding: sp16.paddingHor,
          child: Text(
            option[index].value ?? '',
            textAlign: TextAlign.left,
            style: p5.copyWith(
              color: option[index].dateRange == bloc.state.data?.dateRange
                  ? mainColor
                  : borderColor_4,
              fontWeight: option[index].dateRange == bloc.state.data?.dateRange
                  ? SEMIBOLD
                  : null,
            ),
          ),
        ),
      ),
      itemCount: option.length,
    );
  }

  Container _toolBar(BlocState<ParamDate> state) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: sp8.radiusTop,
        color: mainColor,
      ),
      child: NavigationToolbar(
        leading: Padding(
          padding: sp16.paddingLeft,
          child: BackButton(
            color: Colors.white,
            onPressed: bloc.back,
          ),
        ),
        centerMiddle: false,
        middleSpacing: 0,
        middle: Text(
          state.msg,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: p5.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        trailing: sp16.width,
      ),
    );
  }
}
