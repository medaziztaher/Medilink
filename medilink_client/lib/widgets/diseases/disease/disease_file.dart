import 'package:flutter/material.dart';

import 'components/body.dart';





class DiseaseFile extends StatelessWidget {
  const DiseaseFile({super.key, required this.diseasId});
 final String diseasId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Disease")),
      body: Body(diseasId: diseasId),
    );
  }
}
