import 'package:flutter/material.dart';

import 'components/body.dart';

class AllergyFile extends StatelessWidget {
  const AllergyFile({super.key, required this.alergId});
  final String alergId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Allergy")),
      body: Body(alergId: alergId),
    );
  }
}
