import 'package:flutter/material.dart';

import '../../models/user.dart';
import 'components/body.dart';

class Prescriptions extends StatelessWidget {
  const Prescriptions({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Prscriptions"),
      ),
      body: Body(
        userId: user.id!,
      ),
    );
  }
}
