import 'package:flutter/material.dart';

import '../../../models/user.dart';
import 'components/body.dart';

class UserAllergeys extends StatelessWidget {
  const UserAllergeys({super.key, required this.user});
 final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user.name} Allergy"),
      ),
      body: Body(user : user),
    );
  }
}
