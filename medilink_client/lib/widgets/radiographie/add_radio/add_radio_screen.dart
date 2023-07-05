import 'package:flutter/material.dart';

import '../../../api/user.dart';
import '../../../models/user.dart';
import '../../../utils/global.dart';
import 'components/body.dart';


class AddRadioScreen extends StatefulWidget {
  const AddRadioScreen({super.key, required this.user});
 final User user;

  @override
  State<AddRadioScreen> createState() => _AddRadioScreenState();
}

class _AddRadioScreenState extends State<AddRadioScreen> {
  late Future<String?> _userIdFuture;

  @override
  void initState() {
    _userIdFuture = _initializeUser();
    super.initState();
  }

  Future<String?> _initializeUser() async {
    String? userId = globalUserId;
    if (userId == null) {
      userId = await queryUserID();
    }
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: FutureBuilder<String?>(
          future: _userIdFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading...");
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              final userId = snapshot.data;
              if (userId == widget.user.id) {
                return Text("Add Radiographie");
              } else {
                return Text("Add Radiographie to ${widget.user.name}");
              }
            }
          },
        ),
      ),
      body: FutureBuilder<String?>(
        future: _userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final userId = snapshot.data!;
            return Body(user: widget.user, userId: userId);
          }
        },
      ),
    );
  }
}
