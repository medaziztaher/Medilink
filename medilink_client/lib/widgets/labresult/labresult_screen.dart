import 'package:flutter/material.dart';
import 'components/body.dart';

class LabresultScreen extends StatelessWidget {
  const LabresultScreen ({super.key,required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Analyse"),
      ),
      body: Body(userId : userId),
    );
  }
}