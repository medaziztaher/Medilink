import 'package:flutter/material.dart';

import '../../../../models/metric.dart';
import '../../../../models/user.dart';
import '../../../../settings/networkhandler.dart';
import '../../../../settings/path.dart';
import '../metric_curv_chart.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = false;
  NetworkHandler networkHandler = NetworkHandler();
  List<Metric>? metrics;
  List<bool> showChartList = [];

  Future<List<Metric>> getAllMetric() async {
    try {
      final response = await networkHandler.get(metricsPath);

      final data = response['data'] as List<dynamic>;
      final newMetrics =
          data.map((item) => Metric.fromJson(item)).toList(growable: false);
      showChartList = List.generate(newMetrics.length, (_) => false);

      return newMetrics;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Add new metric value ",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
            FutureBuilder<List<Metric>>(
              future: getAllMetric(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  metrics = snapshot.data;
                  if (metrics == null) {
                    return SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 70,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: metrics!.map((metric) {
                        final index = metrics!.indexOf(metric);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              showChartList[index] = !showChartList[index];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F6FA),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    metric.nom!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              'MetricCurveChart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: metrics?.map((metric) {
                    final index = metrics!.indexOf(metric);
                    if (showChartList[index]) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F6FA),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          child: Center(
                            child: MetricCurveChart(
                              patientId: widget.user.id!,
                              metricName: metric.nom!,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }).toList() ??
                  [],
            ),
          ],
        ),
      ),
    );
  }
}
