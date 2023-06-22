import 'package:flutter/material.dart';

import 'components/body.dart';

class RadioResult extends StatelessWidget {
  const RadioResult({super.key, required this.radioId});
  final String radioId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lab Result")),
      body: Body(radioId: radioId),
    );
  }
}
