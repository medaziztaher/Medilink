import 'package:flutter/material.dart';
import 'package:medilink_client/models/diseases.dart';

import 'components/body.dart';

class EditDiseaseScreen extends StatelessWidget {
  const EditDiseaseScreen({super.key, required this.disease});
  final Disease disease;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${disease.speciality}"),
      ),
      body: Body(disease: disease),
    );
  }
}
