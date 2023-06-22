import 'package:flutter/material.dart';

import 'components/body.dart';


class RadioghraphieScreen extends StatelessWidget {
  const RadioghraphieScreen({super.key, required this.userId});
 final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Radiographie"),
      ),
      body: Body(userId : userId),
    );
  }
}