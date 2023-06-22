import 'package:flutter/material.dart';

import '../../../models/user.dart';
import 'components/body.dart';

class UserRadios extends StatelessWidget {
  const UserRadios({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${user.name} "),
      ),
      body: Body(user: user),
    );
  }
}
