import 'package:flutter/material.dart';

import 'components/body.dart';

class SurgeryScreen extends StatelessWidget {
  const SurgeryScreen({super.key, required this.userId});
 final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Surgery"),
      ),
      body: Body(userId : userId),
    );
  }
}