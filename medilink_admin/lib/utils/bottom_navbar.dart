import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constatnts.dart';
import 'enum.dart';


class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home_filled,
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                  //Get.to(()=>HomeScreen());
                },
              ),
              IconButton(
                icon: Icon(CupertinoIcons.search,
                    color: MenuState.search == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor),
                onPressed: () {
                  //Get.to(()=>SearchScreen());
                },
              ),
              IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: MenuState.notifications == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () {}
                  /*Navigator.pushNamed(context, ProfileScreen.routeName),*/
                  ),
            ],
          )),
    );
  }
}
