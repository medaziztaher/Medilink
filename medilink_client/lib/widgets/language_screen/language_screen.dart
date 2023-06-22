import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/size_config.dart';
import 'components/body.dart';


class LanguageScreen extends StatelessWidget {
   const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
         title: Text("kLanguageScreen".tr),
      ),
      body:const Body() ,
    );
  }
}