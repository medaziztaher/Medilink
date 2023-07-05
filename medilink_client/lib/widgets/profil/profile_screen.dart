import 'package:flutter/material.dart';

import '../../models/user.dart';
import 'components/doctor/doctor.dart';
import 'components/patient/patient.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${user.name}'),
        ),
        body: user.role == 'Patient'
            ? PatientProfil(user: user)
            : user.type == 'Doctor'
                ? DoctorProfil(user: user)
                : Center(
                    child: Text("No data"),
                  ) //ProviderProfil(user:user),
        );
  }
}
