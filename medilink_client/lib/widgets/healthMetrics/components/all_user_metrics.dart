import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../../models/user.dart';
import 'components/body.dart';

class UserMetrics extends StatelessWidget {
  const UserMetrics({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return 
StreamBuilder<ConnectivityResult>(
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
        title: Text("${user.name} metrics"),
      ),
      body: Body(user: user),
    );
  }
  });
  }
}
