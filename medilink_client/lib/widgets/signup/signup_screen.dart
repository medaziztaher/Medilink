import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/body.dart';


class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ksingup".tr),
      ),
      body: Body(),
    );
  }
}
