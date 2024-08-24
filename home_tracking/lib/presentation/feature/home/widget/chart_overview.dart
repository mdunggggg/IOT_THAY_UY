import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_tracking/presentation/blocs/bloc_state.dart';
import 'package:home_tracking/presentation/feature/home/bloc/chart_bloc.dart';
import 'package:home_tracking/shared/extension/ext_num.dart';
import 'package:home_tracking/shared/style_text/style_text.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../model/data_sensor_model.dart';

class ChartOverview extends StatefulWidget {
  const ChartOverview({super.key, required this.bloc});

  final ChartBloc bloc;

  @override
  State<ChartOverview> createState() => _ChartOverviewState();
}

class _ChartOverviewState extends State<ChartOverview> {
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      duration: 1000,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        return Container(
          decoration: BoxDecoration(
            color: seriesIndex == 0
                ? Colors.green.withOpacity(0.5)
                : seriesIndex == 1
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.red.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: 8.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (seriesIndex == 0)
                Text(
                  'Temperature: ${data.temperature}°C',
                  style: StyleApp.bold(color: Colors.white),
                ),
              if (seriesIndex == 1)
                Text(
                  'Humidity: ${data.humidity}%',
                  style: StyleApp.bold(color: Colors.white),
                ),
              if (seriesIndex == 2)
                Text(
                  'Light: ${data.light} lux',
                  style: StyleApp.bold(color: Colors.white),
                ),
              Divider(
                color: Colors.white,
              ),
              Text(
                'Time: ${convertToTime(data.time)}',
                style: StyleApp.bold(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
    _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
      enablePinching: true,
      enableDoubleTapZooming: true,
      enableSelectionZooming: true,
      selectionRectBorderColor: Colors.red,
      selectionRectBorderWidth: 1,
      selectionRectColor: Colors.grey,
    );

    _trackballBehavior = TrackballBehavior(
        enable: true,
        tooltipSettings: InteractiveTooltip(
            enable: true,
            color: Colors.white,
          textStyle: StyleApp.bold(color: Colors.black),
        ),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        lineType: TrackballLineType.vertical,
    );

    // Timer.periodic(Duration(seconds: 6), (timer) {
    //   widget.bloc.getData();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, BlocState>(
      builder: (context, state) {
        return _buildMultipleAxisLineChart();
      },
    );
  }

  SfCartesianChart _buildMultipleAxisLineChart() {
    return SfCartesianChart(
      legend: Legend(isVisible: true),
      enableAxisAnimation: true,
      zoomPanBehavior: _zoomPanBehavior,
      enableSideBySideSeriesPlacement: true,
      trackballBehavior: _trackballBehavior,
      axes: const <ChartAxis>[
        NumericAxis(
            opposedPosition: true,
            name: 'yAxis1',
            majorGridLines: MajorGridLines(width: 0),
            labelFormat: '{value}',
            minimum: 0,
            maximum: 1050,
            interval: 100)
      ],
      primaryXAxis: CategoryAxis(
        labelPlacement: LabelPlacement.onTicks,
        autoScrollingDelta: 5,
        autoScrollingMode: AutoScrollingMode.end,
      ),
      primaryYAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        minimum: 0,
        maximum: 100,
        interval: 10,
        labelFormat: '{value}',
        maximumLabels: 10,
      ),
      series: _getMultipleAxisLineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<CartesianSeries<DataSensorModel, String>> _getMultipleAxisLineSeries() {
    return <CartesianSeries<DataSensorModel, String>>[
      LineSeries<DataSensorModel, String>(
          color: Colors.green,
          dataSource: widget.bloc.list,
          xValueMapper: (DataSensorModel sales, _) => DateFormat('hh:mm:ss')
              .format(DateTime.fromMillisecondsSinceEpoch(sales.time ?? 0)),
          yValueMapper: (DataSensorModel sales, _) => sales.temperature ?? 0,
          name: 'Tempurature',
          enableTooltip: true,
          markerSettings: MarkerSettings(isVisible: true)),
      LineSeries<DataSensorModel, String>(
          color: Colors.blue,
          dataSource: widget.bloc.list,
          xValueMapper: (DataSensorModel sales, _) => DateFormat('hh:mm:ss')
              .format(DateTime.fromMillisecondsSinceEpoch(sales.time ?? 0)),
          yValueMapper: (DataSensorModel sales, _) => sales.humidity ?? 0,
          name: 'Humidity',
          enableTooltip: true,
          markerSettings: MarkerSettings(isVisible: true)),
      LineSeries<DataSensorModel, String>(
          color: Colors.red,
          dataSource: widget.bloc.list,
          yAxisName: 'yAxis1',
          xValueMapper: (DataSensorModel sales, _) => DateFormat('hh:mm:ss')
              .format(DateTime.fromMillisecondsSinceEpoch(sales.time ?? 0)),
          yValueMapper: (DataSensorModel sales, _) => 1024 - (sales.light ?? 0),
          name: 'Light',
          enableTooltip: true,
          markerSettings: MarkerSettings(isVisible: true))
    ];
  }

  int convertToSeconds(int? milliseconds) {
    return (milliseconds ?? 0) ~/ 1000;
  }

  String convertToTime(int? milliseconds) {
    return DateFormat('dd/MM/yyyy hh:mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(milliseconds ?? 0));
  }
}
