import 'package:flutter/material.dart';
import 'components/body.dart';

class LabResult extends StatelessWidget {
  const LabResult({super.key, required this.labid});
  final String labid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lab Result")),
      body: Body(labid: labid),
    );
  }
}
