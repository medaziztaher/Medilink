import 'package:flutter/material.dart';

import '../../../models/allergy.dart';
import 'components/body.dart';

class EditAllergyScreen extends StatelessWidget {
  const EditAllergyScreen({super.key, required this.allergie});
  final Allergy allergie;

  @override
  Widget build(BuildContext context) {
    print("allergy: $allergie");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${allergie.type}"),
      ),
      body: Body(allergie: allergie),
    );
  }
}
