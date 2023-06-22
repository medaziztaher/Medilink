import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/size_config.dart';



class SocialCard extends StatelessWidget {
  const SocialCard({
    super.key, required this.icon, required this.press,
  });
  final String icon;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
        padding: EdgeInsets.all(getProportionateScreenWidth(10)),
        height: getProportionateScreenHeight(50),
        width: getProportionateScreenWidth(50),
      decoration: const BoxDecoration(
        color: Color(0XFFF5F6F9),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(icon),
      
      
      ),
    );
  }
}
