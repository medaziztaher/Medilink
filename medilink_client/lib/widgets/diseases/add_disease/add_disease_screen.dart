import 'package:flutter/material.dart';

import 'components/body.dart';

class AddDiseaseScreen extends StatelessWidget {
  const AddDiseaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add disease"),
      ),
      body: Body(),
    );
  }
}
