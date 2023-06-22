import 'package:flutter/material.dart';

import '../../../models/user.dart';
import 'components/body.dart';

class UserSurgerys extends StatelessWidget {
  const UserSurgerys({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user.name} Surgerys"),
      ),
      body: Body(user: user),
    );
  }
}
