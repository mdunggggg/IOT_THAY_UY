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
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Time: ${convertToTime(data.time)}',
                style: StyleApp.bold(color: Colors.black),
              ),
              if(seriesIndex == 0)
                Text(
                  'Temperature: ${data.temperature}°C',
                  style: StyleApp.bold(color: Colors.black),
                ),
              if(seriesIndex == 1)
                Text(
                  'Humidity: ${data.humidity}%',
                  style: StyleApp.bold(color: Colors.black),
                ),
              if(seriesIndex == 2)
                Text(
                  'Light: ${data.light} lux',
                  style: StyleApp.bold(color: Colors.black),
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
        selectionRectColor: Colors.grey
    );
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
      zoomPanBehavior:  _zoomPanBehavior,
      enableSideBySideSeriesPlacement: true,
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
      tooltipBehavior: _tooltipBehavior,

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
        name: 'Tempurature',
        enableTooltip: true,
      ),
      LineSeries<DataSensorModel, String>(
        dataSource: widget.list,
        xValueMapper: (DataSensorModel sales, _) => DateFormat('hh:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(sales.time ?? 0)),
        yValueMapper: (DataSensorModel sales, _) => sales.humidity ?? 0,
        name: 'Humidity',
        enableTooltip: true,
      ),
      LineSeries<DataSensorModel, String>(
        dataSource: widget.list,
        yAxisName: 'yAxis1',
        xValueMapper: (DataSensorModel sales, _) => DateFormat('hh:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(sales.time ?? 0)),
        yValueMapper: (DataSensorModel sales, _) => sales.light ?? 0,
        name: 'Light',
        enableTooltip: true,
      )
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
    return DateFormat('dd/MM/yyyy hh:mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(milliseconds ?? 0));
  }
}
