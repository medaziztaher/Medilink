import 'package:flutter/material.dart';

import '../../../models/user.dart';
import 'components/body.dart';

class UserDiseases extends StatelessWidget {
  const UserDiseases({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user.name} Diseases"),
      ),
      body: Body(user: user),
    );
  }
}
