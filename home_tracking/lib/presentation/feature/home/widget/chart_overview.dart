import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:home_tracking/shared/extension/ext_date_time.dart';
import 'package:home_tracking/shared/style_text/style_text.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../model/data_sensor_model.dart';

class ChartOverview extends StatefulWidget {
  const ChartOverview({super.key, required this.list});

  final List<DataSensorModel> list;

  @override
  State<ChartOverview> createState() => _ChartOverviewState();
}

class _ChartOverviewState extends State<ChartOverview> {
  @override
  void initState() {
    super.initState();
  }

  bool isCardView = true;

  @override
  Widget build(BuildContext context) {
    return _buildMultipleAxisLineChart();
  }

  /// Returns the chart with multiple axes.
  SfCartesianChart _buildMultipleAxisLineChart() {
    print(widget.list.length);
    return SfCartesianChart(
      title: ChartTitle(
          text: isCardView ? '' : 'Washington vs New York temperature'),
      legend: Legend(isVisible: isCardView),
      enableAxisAnimation: true,
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
      ),

      /// API for multiple axis. It can returns the various axis to the chart.
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
      primaryXAxis: const CategoryAxis(
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
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to
  /// render on the multiple axes chart.
  List<CartesianSeries<DataSensorModel, String>> _getMultipleAxisLineSeries() {
    return <CartesianSeries<DataSensorModel, String>>[
      LineSeries<DataSensorModel, String>(
          dataSource: widget.list,
          xValueMapper: (DataSensorModel sales, _) => DateFormat('hh:mm:ss')
              .format(DateTime.fromMillisecondsSinceEpoch(sales.time ?? 0)),
          yValueMapper: (DataSensorModel sales, _) => sales.temperature ?? 0,
          name: 'Tempurature'),
      LineSeries<DataSensorModel, String>(
          dataSource: widget.list,
          xValueMapper: (DataSensorModel sales, _) => DateFormat('hh:mm:ss')
              .format(DateTime.fromMillisecondsSinceEpoch(sales.time ?? 0)),
          yValueMapper: (DataSensorModel sales, _) => sales.humidity ?? 0,
          name: 'Humidity'),
      LineSeries<DataSensorModel, String>(
          dataSource: widget.list,
          yAxisName: 'yAxis1',
          xValueMapper: (DataSensorModel sales, _) => DateFormat('hh:mm:ss')
              .format(DateTime.fromMillisecondsSinceEpoch(sales.time ?? 0)),
          yValueMapper: (DataSensorModel sales, _) => sales.light ?? 0,
          name: 'Light')
    ];
  }

  @override
  void dispose() {
    widget.list.clear();
    super.dispose();
  }

  int convertToSeconds(int? milliseconds) {
    return (milliseconds ?? 0) ~/ 1000;
  }

  String convertToTime(int? milliseconds) {
    return DateFormat('HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(milliseconds ?? 0));
  }
}
