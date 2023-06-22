import 'package:flutter/material.dart';

import 'components/body.dart';



class SurgeryFile extends StatelessWidget {
  const SurgeryFile({super.key, required this.surgId});
final String surgId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Surgery")),
      body: Body(surgId: surgId),
    );
  }
}
