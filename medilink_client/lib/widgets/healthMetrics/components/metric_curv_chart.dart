import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:medilink_client/settings/networkhandler.dart';

import '../../../settings/path.dart';

NetworkHandler networkHandler = NetworkHandler();
Future<List<Map<String, dynamic>>> fetchHealthMetrics(
    String patientId, String metricName) async {
  final url = '$healthMetricPath/$patientId/$metricName';

  final response = await networkHandler.get(url);
  print("response : $response");
  if (response['status'] == true) {
    final jsonData = response['data'];
    print("jsonData : $jsonData");
    return List<Map<String, dynamic>>.from(jsonData);
  } else {
    throw Exception('Failed to fetch health metrics');
  }
}

List<double> extractValues(List<Map<String, dynamic>> healthMetrics) {
  return healthMetrics
      .map<double>((metric) => metric['value'].toDouble())
      .toList();
}

List<DateTime> extractDates(List<Map<String, dynamic>> healthMetrics) {
  return healthMetrics
      .map<DateTime>((metric) => DateTime.parse(metric['date']))
      .toList();
}

charts.Series<HealthMetric, DateTime> createMetricSeries(
    List<Map<String, dynamic>> healthMetrics) {
  final metricData = healthMetrics.map((metric) {
    final date = DateTime.parse(metric['date']);
    final value = metric['value'].toDouble();
    return HealthMetric(date: date, value: value);
  }).toList();

  return charts.Series<HealthMetric, DateTime>(
    id: 'Metric',
    data: metricData,
    domainFn: (HealthMetric metric, _) => metric.date,
    measureFn: (HealthMetric metric, _) => metric.value,
  );
}

class HealthMetric {
  final DateTime date;
  final double value;

  HealthMetric({required this.date, required this.value});
}

class MetricCurveChart extends StatefulWidget {
  final String patientId;
  final String metricName;

  MetricCurveChart({required this.patientId, required this.metricName});

  @override
  _MetricCurveChartState createState() => _MetricCurveChartState();
}

class _MetricCurveChartState extends State<MetricCurveChart> {
  late Future<List<Map<String, dynamic>>> _fetchHealthMetricsFuture;

  @override
  void initState() {
    super.initState();
    _fetchHealthMetrics();
  }

  Future<void> _fetchHealthMetrics() async {
    try {
      _fetchHealthMetricsFuture = fetchHealthMetrics(
        widget.patientId,
        widget.metricName,
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchHealthMetricsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Failed to fetch health metrics'),
          );
        } else if (snapshot.hasData) {
          final healthMetrics = snapshot.data!;
          final values = extractValues(healthMetrics);
          final dates = extractDates(healthMetrics);
          final series = createMetricSeries(healthMetrics);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(16.0),
              scaleEnabled: true,
              child: charts.TimeSeriesChart(
                [series],
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
              ),
            ),
          );
        } else {
          return Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }
}