import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/body.dart';


class SignInScreen extends StatelessWidget {
  static String routeName = "/signin";
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ksignin".tr),
      ),
      body: const Body(),
    );
  }
}
