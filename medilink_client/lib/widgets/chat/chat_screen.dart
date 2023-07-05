import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/bottom_navbar.dart';
import '../../utils/enum.dart';
import 'components/body.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.data == ConnectivityResult.none) {
            return Scaffold(
              body: Center(
                child: AlertDialog(
                  title: Text('No Internet Connection'),
                  content: Text('Please check your internet connection.'),
                ),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text("Chats"),
                ),
                body: Body(),
                bottomNavigationBar: const CustomBottomNavBar(
                    selectedMenu: MenuState.messenger));
          }
        });
  }
}
