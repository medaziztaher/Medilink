import 'package:flutter/material.dart';

import '../../utils/size_config.dart';
import 'components/body.dart';


class AllergysScreen extends StatelessWidget {
  const AllergysScreen({super.key, required String userId});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("New Allergy"),
      ),
      body: Body(),
    );
  }
}