import 'package:flutter/material.dart';
import 'package:medilink_client/models/prescription.dart';

import 'components/body.dart';

class EditPrescScreen extends StatelessWidget {
  const EditPrescScreen(
      {super.key, required this.prescription, required this.userId});
  final Prescription prescription;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${prescription.medication}"),
      ),
      body: Body(prescription: prescription, userId: userId),
    );
  }
}
