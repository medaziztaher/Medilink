import 'package:flutter/material.dart';

import '../../../models/user.dart';
import 'components/body.dart';

class UserMetrics extends StatelessWidget {
  const UserMetrics({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${user.name} metrics"),
      ),
      body: Body(user: user),
    );
  }
}
