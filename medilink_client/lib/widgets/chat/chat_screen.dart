import 'package:flutter/material.dart';

import '../../components/bottom_navbar.dart';
import '../../utils/enum.dart';
import 'components/body.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Chats"),
        ),
        body: Body(),
        bottomNavigationBar:
            const CustomBottomNavBar(selectedMenu: MenuState.messenger));
  }
}
