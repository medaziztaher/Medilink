import 'package:flutter/material.dart';

import 'components/body.dart';

class PrescriptionFile extends StatelessWidget {
  const PrescriptionFile({super.key, required this.presId});
  final String presId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PrescriptionFile")),
      body: Body(presId: presId),
    );
  }
}
