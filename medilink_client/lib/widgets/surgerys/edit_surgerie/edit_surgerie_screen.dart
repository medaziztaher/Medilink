import 'package:flutter/material.dart';
import 'package:medilink_client/models/surgery.dart';

import 'components/body.dart';

class EditSurgerieScreen extends StatelessWidget {
  const EditSurgerieScreen(
      {super.key, required this.surgerie, required this.userId});
  final Surgerie surgerie;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${surgerie.type}"),
      ),
      body: Body(surgerie: surgerie, userId: userId),
    );
  }
}
