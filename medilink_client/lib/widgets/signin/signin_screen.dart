import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/body.dart';


class SignInScreen extends StatelessWidget {
  static String routeName = "/signin";
  const SignInScreen({super.key});

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
          
          } else {return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ksignin".tr),
      ),
      body: const Body(),
    );
          }
  });
  }
}
