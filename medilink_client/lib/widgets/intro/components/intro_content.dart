
import 'package:flutter/material.dart';

import '../../../utils/constatnts.dart';
import '../../../utils/size_config.dart';


class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.text,
    required this.image,
  }) : super(key: key);

  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          const Spacer(),
          Text(
            "Medilink",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(36),
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
          Image.asset(
            image,
            height: SizeConfig.defaultSize,
            width: getProportionateScreenWidth(235),
          ),
        ],
      ),
    );
  }
}