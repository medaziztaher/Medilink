import 'package:flutter/material.dart';

import 'components/body.dart';


class SplashScreen extends StatelessWidget {
  static String routeName = "/";
  
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
    );
  }
}