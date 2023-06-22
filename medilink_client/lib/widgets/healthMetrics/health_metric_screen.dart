import 'package:flutter/material.dart';

import 'components/metri_form.dart';

class MetricScreen extends StatelessWidget {
  const MetricScreen({super.key, required this.metric});
  final String metric;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MetricForm(metric : metric),
    );
  }
}
