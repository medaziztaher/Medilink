import 'package:flutter/material.dart';
import 'package:medilink_client/models/user.dart';

import '../../components/bottom_navbar.dart';
import '../../utils/enum.dart';
import 'components/body.dart';

class DossierMedicale extends StatelessWidget {
  const DossierMedicale({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("${user.name}"),
        ),
        body: Body(user: user),
        bottomNavigationBar: user.role == 'Patient'
            ? const CustomBottomNavBar(selectedMenu: MenuState.rapports)
            : null);
  }
}
