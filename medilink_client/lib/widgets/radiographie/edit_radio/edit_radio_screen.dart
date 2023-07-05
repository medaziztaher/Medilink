import 'package:flutter/material.dart';
import 'package:medilink_client/models/radiographie.dart';

import 'components/body.dart';

class EditRadioScreen extends StatelessWidget {
  const EditRadioScreen(
      {super.key, required this.radiographie, required this.userId});
  final Radiographie radiographie;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${radiographie.type}"),
      ),
      body: Body(radiographie: radiographie, userId: userId),
    );
  }
}
