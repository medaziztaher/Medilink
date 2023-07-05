import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'components/metri_form.dart';

class MetricScreen extends StatelessWidget {
  const MetricScreen({super.key, required this.metric});
  final String metric;

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
      body: MetricForm(metric : metric),
    );
          }
  });
  
  }
}
