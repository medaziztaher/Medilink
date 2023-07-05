import 'package:flutter/material.dart';

import 'components/body.dart';

class AddAllergyScreen extends StatelessWidget {
  const AddAllergyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Allergy"),
      ),
      body: Body(),
    );
  }
}
