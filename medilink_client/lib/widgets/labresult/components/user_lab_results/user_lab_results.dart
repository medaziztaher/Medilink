import 'package:flutter/material.dart';

import '../../../../models/user.dart';
import 'components/body.dart';

class UserLabs extends StatelessWidget {
  const UserLabs({super.key, required this.user});
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
