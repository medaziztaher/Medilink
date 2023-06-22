import 'package:flutter/material.dart';

import '../../../models/user.dart';
import 'components/body.dart';

class UserPrescriptions extends StatelessWidget {
  const UserPrescriptions({super.key, required this.user});
final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user.name} Labs"),
      ),
      body: Body(user : user),
    );
  }
}
