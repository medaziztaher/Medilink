import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:medilink_client/models/user.dart';

import 'components/body.dart';

class BookAppointment extends StatelessWidget {
  const BookAppointment({super.key, required this.provider});
  final User? provider;
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
        title: Text("Book appointment"),
      ),
      body: Body(providerId: provider!.id!,price : provider!.appointmentprice)
    );
           }
        });
  }
}

