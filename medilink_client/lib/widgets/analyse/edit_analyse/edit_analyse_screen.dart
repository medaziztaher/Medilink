import 'package:flutter/material.dart';

import '../../../models/labresult.dart';
import 'components/body.dart';

class EditAnalyseScreen extends StatelessWidget {
  const EditAnalyseScreen(
      {super.key, required this.analyse, required this.userId});
  final Labresult analyse;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${analyse.test}"),
      ),
      body: Body(analyse: analyse, userId: userId),
    );
  }
}
