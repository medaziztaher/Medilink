import 'package:flutter/material.dart';

import '../../../models/metric.dart';
import '../../../services/networkhandler.dart';
import '../../../services/path.dart';

class AddMetrics extends StatefulWidget {
  const AddMetrics({Key? key}) : super(key: key);

  @override
  State<AddMetrics> createState() => _AddMetricsState();
}

class _AddMetricsState extends State<AddMetrics> {
  bool isloading = false;
  bool iscircular = false;
  NetworkHandler networkHandler = NetworkHandler();
  List<Metric> metrics = [];
  late String newMetric;

  Future<void> addMetrics(String metric) async {
    setState(() {
      isloading = true;
    });
    final data = {
      'metric': metric,
    };
    try {
      await networkHandler.post(metricsPath, data);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> deleteMetric(String id) async {
    setState(() {
      isloading = true;
    });
    try {
      await networkHandler.delete("$metricsPath/$id");
      await getAllMetric();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> getAllMetric() async {
    setState(() {
      iscircular = true;
    });
    try {
      final response = await networkHandler.get(metricsPath);

      final data = response['data'] as List<dynamic>;
      final newMetrics =
          data.map((item) => Metric.fromJson(item)).toList(growable: false);
      setState(() {
        metrics = newMetrics;
        print(metrics);
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        iscircular = false;
      });
    }
  }

  Future<void> updateMetric(String id, String metric) async {
    setState(() {
      isloading = true;
    });
    final data = {
      'metric': metric,
    };
    try {
      await networkHandler.put("$metricsPath/$id", data);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllMetric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Specialities'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                Text("Add Speciality"),
                TextField(
                  onChanged: (value) {
                    newMetric = value;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    await addMetrics(newMetric);
                    await getAllMetric();
                  },
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text("Speciality List"),
            Expanded(
              child: iscircular
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: metrics.length,
                      itemBuilder: (BuildContext context, int index) {
                        Metric metric = metrics[index];
                        print(metric);
                        return ListTile(
                          title: Text(metric.nom ?? ""),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await deleteMetric(metric.id!);
                              await getAllMetric();
                            },
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Change'),
                                  content: TextField(
                                    onChanged: (value) {
                                      newMetric = value;
                                    },
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await updateMetric(
                                          metric.id!,
                                          newMetric,
                                        );
                                        await getAllMetric();
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
