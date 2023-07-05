import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/global.dart';
import 'components/doctorcompletprofile/doctorform.dart';
import 'components/patientcommpletform/patientForm.dart';
import 'components/providercompletprofile/providerForm.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";

  CompleteProfileScreen({super.key});

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
                title: Text('ksingup'.tr),
              ),
              body: globalRole == 'Patient'
                  ? PatienForm()
                  : globalType == 'Doctor'
                      ? DoctorForm()
                      : ProviderForm(),
            );
          }
        });
  }
}
